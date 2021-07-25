echo $1
grep -H "BLEU" $1/nist*_moses.eval|awk '{print $1" "$3}'|sed 's/.*\/run/ /g'
echo "--------------------------------------------------"
grep -H "BLEU" $1/nist*_moses.eval|awk '{print $1" "$3}'|sed 's/.*\/run/ /g'
