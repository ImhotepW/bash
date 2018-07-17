#!/bin/bash

## This script adds random objects to QV dashboard

# Setting main parameters
source qvcodgen.cfg
vTXCnt=$(( RANDOM % 40 + 40))

function tx_templ(){
  echo
}

csplit -s -f first $vDashboardPath/QlikViewProject.xml '/'$vSheetId'/' 
csplit -s -f second first01 '/</ChildObjects>/'

echo 'Going to generate' $vTXCnt 'text objects in '$vDashboardPath
for i in $(seq $(( 1+vTXLast )) $(( vTXCnt+vTXLast )))
do
  # Generating TX object
  export BkgColorR=$(( RANDOM % 255 )) BkgColorG=$(( RANDOM % 255 )) BkgColorB=$(( RANDOM % 255 ))
  TextClr=$(awk 'BEGIN {print (1-(0.299*'$BkgColorR'+0.587*'$BkgColorG'+0.114*'$BkgColorB')/255 < 0.5) ? 0 : 255}')
  export TextClrR=$TextClr TextClrG=$TextClr TextClrB=$TextClr
  export Text=$(sed -n $vTXWordIndex'p' words.txt)
  ((vTXWordIndex++))
  envsubst < TX.template > $vDashboardPath/TX$(printf "%04d" $i).xml
  
  # Inserting TX link to QlikViewProject.xml
 #csplit -s -f first $vDashboardPath/QlikViewProject.xml '/'$vSheetId'/' 
 #csplit -s -f second first01 '/</ChildObjects>/'
  export txid=TX$(printf "%04d" $i)
  
  export PositionL=$(( (((i-1)*vTXWidth)%vTXMaxInRow)*vTXWidth ))
  export PositionT=$(( ((i-1)/vTXMaxInRow + 1)*vTXHeight  ))
  export Width=$vTXWidth 
  export Height=$vTXHeight
  envsubst < QVPrjTX.template >> second00
  
  #cat first00 second00 second01 > $vDashboardPath/QlikViewProject.xml
  #rm first0* second0*  
done

# Cleaning
cat first00 second00 second01 > $vDashboardPath/QlikViewProject.xml
rm first0* second0*  


# Updating config file
sed -i "s/^\(vTXLast\s*=\s*\).*$/\1$i/" qvcodgen.cfg
sed -i "s/^\(vTXWordIndex\s*=\s*\).*$/\1$vTXWordIndex/" qvcodgen.cfg




#TextClrR=0 TextClrG=0 TextClrB=0 BkgColorR=34 BkgColorB=183 BkgColorG=200 Text="This is custom"  envsubst < TX.template > ./testapp-prj/TX003.xml
#SheetName=Sheet002 envsubst < SH.template > ./testapp-prj/SH002.xml

##sed '/<\/SHEETS>/i/\sometext' QlikViewProject.xml


# Commands to substitute variables in a file
#sed -e "s/\$var/1/" TX_template.xml  > TX$var.xml
#var=7 envsubst < TX_template.xml > TX7.xml