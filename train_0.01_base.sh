train_from=/panfs/panmt/users/xmyang/nmt/cost_future/baseline/zh2en_model_baseline_4_4096_bpe/model_step_40000.pt
gpu_num=3
batchsize=4096
accumcount=4
model_path=zh2en_model_futurecost_0.01base_${accumcount}_${batchsize}_bpe

#CUDA_VISIBLE_DEVICES=$gpu_num python train.py -data ../thumt_data/data/zh2en.eighty -save_model ./zh2en_model_$batchsize/model -gpu_ranks 0 \
#        -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
#        -encoder_type transformer -decoder_type transformer -position_encoding \
#        -train_steps 300000 -max_generator_batches 32 -dropout 0.1 \
#        -batch_size $batchsize -batch_type tokens -normalization tokens -accum_count 4 \
#        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
#        -max_grad_norm 0 -param_init 0 -param_init_glorot -report_every 100 \
#        -label_smoothing 0.1 -valid_steps 2000 -save_checkpoint_steps 2000 \
#        -log_file ./zh2en_model_$batchsize/log.txt > ./zh2en_model_$batchsize/ppl_acc.txt 
#cd /share03/mmyang/nmt/cost_future/layermask
# `./idle-gpus.pl -n 1`
mkdir $model_path
CUDA_VISIBLE_DEVICES=$gpu_num python train.py -data ../data/zh2en.eighty -save_model ./$model_path/model -gpu_ranks 0 \
        -train_from $train_from -reset_optim all \
        -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
        -encoder_type transformer -decoder_type transformer -position_encoding \
        -train_steps 150000 -max_generator_batches 32 -dropout 0.1 \
        -batch_size $batchsize -batch_type tokens -normalization tokens -accum_count 4 \
        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
        -max_grad_norm 0 -param_init 0 -param_init_glorot -report_every 100 \
        -label_smoothing 0.1 -valid_steps 2000 -save_checkpoint_steps 2000 \
        -log_file ./$model_path/log.txt > ./$model_path/ppl_acc.txt 

