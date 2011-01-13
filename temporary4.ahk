#include FcnLib.ahk

;try to run a cloud ahk

DeleteTraceFile()

while true
{
   CheckTheCloud()
   SleepSeconds(15)
}

`:: ExitApp

examineStrs(str1, str2)
{
   ;debug(strlen(str1), strlen(str2))
   AddToTrace(strlen(str1), strlen(str2))

   chars := strlen(str2)
   loop %chars%
   {
      char1:=substr(str1, A_Index, 1)
      char2:=substr(str2, A_Index, 1)
      equal:= substr(str1, A_Index, 1) == substr(str2, A_Index, 1)
      AddToTrace(char1, char2, equal, asc(char1), asc(char2) )

      ;debug( substr(str1, A_Index, 1), substr(str2, A_Index, 1) )
   }
}

checkTheCloud()
{
   dry_run := true
   EntireAlgTimer:=starttimer()
   ;if (A_ComputerName="PHOSPHORUS")
   {
      ;while true
      ;{
      ;TODO detect duplicate divs... if so, make the req again
      ;TODO or we could make the req 5 times in a row. if all five weren't identical, we can make the req again
      codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")
      last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt")
      ;}

      originalCode:=codefile
      originalReq:=last

      ;give us just the section that we want
      codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
      RegExMatch(codefile, "sites-layout-name-one-column.*?tbody...table", codefile)
      codefile:=RegExReplace(codefile, "ZZZnewlineZZZ", "`n")

      ;get rid of some of the html
      codefile:=RegExReplace(codefile, "\<div\>", "`n")
      codefile:=RegExReplace(codefile, "\<.*?\>", "")
      codefile:=RegExReplace(codefile, "^.*?\>", "")
      codefile:=RegExReplace(codefile, "\<.*?$", "")

      ;odd that this shows up
      codefile:=RegExReplace(codefile, "remoteahk\n", "")

      ;codefile:=StringReplace(codefile, chr(194), "", "All")
      ;last:=StringReplace(last, chr(194), "", "All")

      codefile:=RegExReplace(codefile, "(`r|`n|`r`n)", "`n")
      last:=RegExReplace(last, "(`r|`n|`r`n)", "`n")
      ;debug(codefile, "zzz", last)

      stripExpr:="[^!@#$%^&*(){}a-zA-Z0-9 \r\n]"
      stripExpr:="\n+"
      replExpr:="`n"
      codefilestripped:=RegExReplace(codefile, stripExpr, replExpr)
      lastfilestripped:=RegExReplace(last, stripExpr, replExpr)

      if (codefilestripped != lastfilestripped)
      {
         delog("new version detected... going to run it")
         examineStrs(codefilestripped, lastfilestripped)

         time:=CurrentTime("hyphenated")
         FileAppend, %originalCode%, C:\My Dropbox\Public\ahkerrors\cloudahk\%time%-original.html
         FileAppend, %codefile%, C:\My Dropbox\Public\ahkerrors\cloudahk\%time%-processed.ahk

         FileDelete, C:\My Dropbox\Public\latestCloudAhk.txt
         FileAppend, %codefile%, C:\My Dropbox\Public\latestCloudAhk.txt
         timestamp := CurrentTime()
         if NOT dry_run
            FileAppend, %codefile%, C:\My Dropbox\AHKs\scheduled\phosphorus\%timestamp%.ahk

         ;need to sleep and let dropbox load the new version of the file to the server
         ;TODO 20 s was not enough (sheesh)... should we ping the hell out of it to see if it has changed?
         dropboxUploadTimer:=starttimer()
         while (originalReq == urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt"))
            SleepSeconds(1)
         AddToTrace("Took this long for dropbox to upload:",elapsedtime(dropboxUploadTimer))
      }

      ;TODO need a fcn that gives local dropbox folder location and remote dropbox folder location
   }
   AddToTrace("Elapsed Time:",elapsedtime(EntireAlgTimer))
}
