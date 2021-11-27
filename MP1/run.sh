#!/bin/bash

mkdir -p compiled images

#compile the txt file to a fst file
for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done



#A2R  
echo "Compiling: A2R"
fstinvert compiled/R2A.fst > compiled/A2R.fst

#birthA2T
echo "Compiling: birthA2T"
fstconcat compiled/copy.fst compiled/copy.fst > compiled/tmp1.fst  #copies two digits (dd)
fstconcat compiled/tmp1.fst compiled/copy.fst > compiled/tmp2.fst #copies three digits (dd + '/')
fstconcat compiled/tmp2.fst compiled/mm2mmm.fst > compiled/tmp3.fst #copies three digits, then translates the month to text
fstconcat compiled/tmp3.fst compiled/tmp2.fst > compiled/tmp4.fst #copies more three digits ('/' + yy)
fstconcat compiled/tmp4.fst compiled/tmp1.fst | fstarcsort > compiled/birthA2T.fst #copies more two digits (yy)
rm compiled/tmp*

#birthR2A
echo "Compiling: birthR2A"
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/tmp1.fst  #translates the day and puts it on the form dd
fstconcat compiled/tmp1.fst compiled/copy.fst > compiled/tmp2.fst #copies the '/'
fstconcat compiled/tmp2.fst compiled/tmp1.fst > compiled/tmp3.fst #translates the month and puts it on the form mm
fstcompose compiled/R2A.fst compiled/d2dddd.fst > compiled/tmp4.fst #transducer that translates from R2A and puts it on the form dddd
fstconcat compiled/tmp3.fst compiled/copy.fst > compiled/tmp5.fst #reads the second '/'
fstconcat compiled/tmp5.fst compiled/tmp4.fst > compiled/birthR2A.fst #Translates the year
rm compiled/tmp*

#birthT2R
echo "Compiling: birthT2R"
fstinvert compiled/birthA2T.fst > compiled/tmp1.fst # birthT2A
fstinvert compiled/birthR2A.fst > compiled/tmp2.fst #birthA2R
fstcompose compiled/tmp1.fst compiled/tmp2.fst > compiled/birthT2R.fst #birthT2R
rm compiled/tmp*


#birthR2A
echo "Compiling: birthR2L"
fstcompose compiled/birthR2A.fst compiled/date2year.fst > compiled/tmp1.fst  #translates to arabic than extracts the year
fstcompose compiled/tmp1.fst compiled/leap.fst > compiled/birthR2L.fst #transforms the year into leap or not leap
rm compiled/tmp*

#tests
#testing birthR2A
echo "Testing the transducer 'birthR2A' with the input 'tests/92485birthR2A.txt' (generating pdf)"
fstcompose compiled/92485birthR2A.fst compiled/birthR2A.fst | fstshortestpath > compiled/92485birthR2Atest.fst

echo "Testing the transducer 'birthR2A' with the input 'tests/92485birthR2A.txt' (stdout)"
fstcompose compiled/92485birthR2A.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthR2A' with the input 'tests/92479birthR2A.txt' (generating pdf)"
fstcompose compiled/92479birthR2A.fst compiled/birthR2A.fst | fstshortestpath > compiled/92479birthR2Atest.fst

echo "Testing the transducer 'birthR2A' with the input 'tests/92479birthR2A.txt' (stdout)"
fstcompose compiled/92479birthR2A.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

#testing birthA2T
echo "Testing the transducer 'birthA2T' with the input 'tests/92485birthA2T.txt' (generating pdf)"
fstcompose compiled/92485birthA2T.fst compiled/birthA2T.fst | fstshortestpath > compiled/92485birthA2Ttest.fst

echo "Testing the transducer 'birthA2T' with the input 'tests/92485birthA2T.txt' (stdout)"
fstcompose compiled/92485birthA2T.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthA2T' with the input 'tests/92479birthA2T.txt' (generating pdf)"
fstcompose compiled/92479birthA2T.fst compiled/birthA2T.fst | fstshortestpath > compiled/92479birthA2Ttest.fst

echo "Testing the transducer 'birthA2T' with the input 'tests/92479birthA2T.txt' (stdout)"
fstcompose compiled/92479birthA2T.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


#testing birthT2R
echo "Testing the transducer 'birthT2R' with the input 'tests/92485birthT2R.txt' (generating pdf)"
fstcompose compiled/92485birthT2R.fst compiled/birthT2R.fst | fstshortestpath > compiled/92485birthT2Rtest.fst

echo "Testing the transducer 'birthT2R' with the input 'tests/92485birthT2R.txt' (stdout)"
fstcompose compiled/92485birthT2R.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthT2R' with the input 'tests/92479birthT2R.txt' (generating pdf)"
fstcompose compiled/92479birthT2R.fst compiled/birthT2R.fst | fstshortestpath > compiled/92479birthT2Rtest.fst

echo "Testing the transducer 'birthT2R' with the input 'tests/92479birthT2R.txt' (stdout)"
fstcompose compiled/92479birthT2R.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



#testing birthR2L
echo "Testing the transducer 'birthR2L' with the input 'tests/92485birthR2L.txt' (generating pdf)"
fstcompose compiled/92485birthR2L.fst compiled/birthR2L.fst | fstshortestpath > compiled/92485birthR2Ltest.fst

echo "Testing the transducer 'birthR2L' with the input 'tests/92485birthR2L.txt' (stdout)"
fstcompose compiled/92485birthR2L.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthR2L' with the input 'tests/92479birthR2L.txt' (generating pdf)"
fstcompose compiled/92479birthR2L.fst compiled/birthR2L.fst | fstshortestpath > compiled/92479birthR2Ltest.fst

echo "Testing the transducer 'birthR2L' with the input 'tests/92479birthR2L.txt' (stdout)"
fstcompose compiled/92479birthR2L.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


#create the pdf files
for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done