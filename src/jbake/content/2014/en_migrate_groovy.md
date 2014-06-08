title=Migrating to MS SQL with bcp and Groovy
date=2014-05-28
type=post
tags=groovy, script, migration
status=published
~~~~~~
First of all, why bcp and Groovy and not one of the existing tools like Flyway or something else?
Well, migration is a one-off process to my mind, so why not script it; so you have a 100% percent of knowledge and control of how you do it. And having Groovy as a 'script' language brings lots of stuff to turn your 'script' into a tool really.

As an input I had a set of plain text pipe-delimeted table extracts. Before I could load those I needed to produce a new set of files having old data merged, transformed and new PK added (simple bigint increment). I could've loaded everything into the DB and do that with SQL, but why. At worst I had an 8 million records hashmap in memory, other then that everything was dumped into a file straight away.

On the good side, as a result of my migration I get a set of files which could be used to create/restore a ready-to-go DB wherever I need.

I've created a builder-like class Migrator to encapsulate file traversing, regex matching and writing to output. [Here's the source](https://github.com/bashnesnos/scripts/blob/master/migrator/Migrator.groovy). It also helps to increase readability I hope and reduces the size of the main migration script. It is going to be a core of my migration script.

Now we've came to the migration script itself, which basically will do the following:
1.  Define source files
2.  For each source file defined:
    2.1.    Get file
    2.2.    Transform each line and save it to a declared output file
    2.3.    Upload results

And here how we do it (ommiting the declaration and utility methods) and [here's the example source too](https://github.com/bashnesnos/scripts/blob/master/migrator/example/migrate.groovy):

    migrator.with { 
        //defining a source: 
        source { //loading rainbow table: encrypted -> unencrypted
            inputFile "(?i)top_entity_tab.*"
            outputFile "topEntity.bcp"
            linePattern(/(\w+)$rT.+?$rT(.+?)$rT.*/)
            onMatch { entityId, encrypted -> //transforming a source
                rainbow[encrypted] = entityId
                "$entityId${sT}1"
            }
            tableName "[dbo].[TopEntity]"
        }

        source { //grabbing code-set A
            inputFile "(?i)code_tab.*"
            outputFile  "Code.bcp"
            onMatch {line -> line} //keeping the same
        }

        source { //grabbing code-set B
            inputFile "(?i)another_code_tab.*"
            outputFile "Code.bcp"
            appendOutput true
            onMatch {line -> line} //keeping the same
            doLast {
                new File(outputFile).append("?|Code type unknown (migration)|\r\n") //adding new type, just an example
            }
        }

        source { //uploading merged Code.bcp here, because we needed to add additional line in the of code-set B grabbing
            inputFile "Code.bcp"
            tableName "[dbo].[Code]"
        }

        source {
            inputFile "(?i)entry_tab.*"
            outputFile "Entry.bcp"
            linePattern(/(^(\w+)$rT([- 0-9:]+)$rT)((?:(\d{4})-(\d{2})-(\d{2}).*?)?$rT)([MD]?)($rT(?:\d{4}-\d{2}-\d{2})?)($rT.*$rT[DWR]$rT.*?$rT)0x.*?$rT(.*)/)
            onMatch { Matcher mtchr -> 
                def master = mtchr.group(2)
                def entryTime = mtchr.group(3)
                def lastUpdated = mtchr.group(11)
                return "${mtchr.group(1)}${toDateString(entryTimeFormat,mtchr.group(5), mtchr.group(6),mtchr.group(7),mtchr.group(8))}${mtchr.group(9)}${mtchr.group(10)}$lastUpdated${sT}${sT}${algyId++}"
            }
        }

        source {
            inputFile "(?i)descr_tab.*"
            outputFile "Desciption.bcp"
            linePattern(/((?:.*?$rT){2})(.*?)?((?:$rT?.*?){3}$rT)(\d{4}-\d{2}-\d{2}$rT.*)/)
            onMatch { Matcher mtchr ->
                def ids = mtchr.group(1)
                def encrypted = ids.substring(ids.indexOf("$sT") + 1, ids.lastIndexOf("$sT"))
                def orig = rainbow[encrypted]
                if (orig != null) {
                    ids = ids.replace(encrypted, orig)
                    return lastline = "${ids}${mtchr.group(2)}${mtchr.group(3)}${mtchr.group(4)}"
                }
                else {
                    if (skippedLinesFileWriter != null) {
                        skippedLinesFileWriter.println "descr_tab\n${mtchr.group(0)}"
                    }
                    else {
                        terminate "Orphaned descr detected\n ${mtchr.group(0)}"
                    }                
                }
                return
            }
            tableName "[dbo].[Description]"
            doLast { 
                LOGGER.info lastline
                createIdentity('DescrId', lastline.substring(0, lastline.indexOf("$sT")))
            }
        }


        upload { table, inFile -> //calling bcp or making a batch file
            formatFile = makeFormatFile(table, inFile)
            LOGGER.info "Uploading data to [$server].[$dbname].$table"
            execAndWait "bcp $table in ${getFileNameFromPath(inFile)} -S $server -d $dbname -b 500000 -m 0 -f $formatFile -T -e skipped_${getFileNameFromPath(inFile).replace('.bcp','')}.txt"
            printTimePassed("Tranfser of ${getFileNameFromPath(inFile)} finished.")
        }

        //doing indexes
        LOGGER.info "Creating indexes"
        execAndWait "sqlcmd -S $server -d $dbname -E -i allIndexes.sql"

        if (options.b) {
            batchFileWriter.println 'echo "Migration successfull!"'
            batchFileWriter.close()
        }

        printTimePassed("Migration successful!")
    }


It's a simplified example of what I had, but it has some key things like loading a hashmap with data, joining input files etc. 
As you can see, it is pretty straight-forward. I'll just add some comments for clarity:
* Sources are processed in the definition order, one source file could defined as many times as you need (i.e. no unique checks at all).
* Input files are defined with regexes as well (as I don't care about any date markes or case problems in the file name)
* In this case, processing is triggered by the 'upload' closure which in it's turn is being called per each source when all the lines are processed. And only if the 'tableName' is specified (i.e. where to upload)
* 'onMatch' - is a transformation closure, called for each line in the source file
* 'doLast' - an Gradle-inspired callback closure, called per each file and when 'upload' closure (if any) has finished; so it's the last action taken against 'this' closure.
* 'printTimePassed', 'terminate' - are Migrator's helper methods

And that's done. These scripts require nothing but Groovy (tested in 2.2.1 but will work in previous versions where typed Closures are allowed I guess too) or could be compiled and run just with Java (though migrate.groovy will require apache-cli apart from groovy-all). Pretty light-weight and readable with full control of what you're doing.