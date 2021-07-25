step=12000
result=result_from_test_4_4096_bpe_$step
gpu=0
model_path=zh2en_model_futurecost_from_test_4_4096_bpe
mkdir $result
#CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist02.bpe.cn -output ./$result/nist02.bpe.zh.output
CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist03.bpe.cn -output ./$result/nist03.bpe.zh.output
CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist04.bpe.cn -output ./$result/nist04.bpe.zh.output
CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist05.bpe.cn -output ./$result/nist05.bpe.zh.output
CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist06.bpe.cn -output ./$result/nist06.bpe.zh.output
#CUDA_VISIBLE_DEVICES=$gpu python translate.py -gpu 0 -model $model_path/model_step_$step.pt -src ../thumt_data/test_data/nist08.bpe.cn -output ./$result/nist08.bpe.zh.output

#sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist02.bpe.zh.output > ./$result/nist02.out
sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist03.bpe.zh.output > ./$result/nist03.out
sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist04.bpe.zh.output > ./$result/nist04.out
sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist05.bpe.zh.output > ./$result/nist05.out
sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist06.bpe.zh.output > ./$result/nist06.out
#sed -r 's/(@@ )|(@@ ?$)//g' < ./$result/nist08.bpe.zh.output > ./$result/nist08.out

#sed -n '1,878p' ./$result/nist.out > ./$result/nist_2002.out
#sed -n '879,1797p' ./$result/nist.out > ./$result/nist_2003.out
#sed -n '1798,3585p' ./$result/nist.out > ./$result/nist_2004.out
#sed -n '3586,4667p' ./$result/nist.out > ./$result/nist_2005.out
#sed -n '3790,5453p' ./$result/nist.out > ./$result/nist_2006.out
#sed -n '4668,6024p' ./$result/nist.out > ./$result/nist_2008.out

#perl ./tools/multi-bleu.perl ../thumt_data/temp/nist02.ref < ./$result/nist02.out > ./$result/nist02_moses.eval
perl ./tools/multi-bleu.perl ../thumt_data/temp/nist03.ref < ./$result/nist03.out > ./$result/nist03_moses.eval
perl ./tools/multi-bleu.perl ../thumt_data/temp/nist04.ref < ./$result/nist04.out > ./$result/nist04_moses.eval
perl ./tools/multi-bleu.perl ../thumt_data/temp/nist05.ref < ./$result/nist05.out > ./$result/nist05_moses.eval
perl ./tools/multi-bleu.perl ../thumt_data/temp/nist06.ref < ./$result/nist06.out > ./$result/nist06_moses.eval
#perl ./tools/multi-bleu.perl ../thumt_data/temp/nist08.ref < ./$result/nist08.out > ./$result/nist08_moses.eval

sh ./look_result.sh ./$result > ./$result/result.eval
