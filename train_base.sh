gpu_num=1
batchsize=6250
accumcount=4
mkdir zh2en_model_$batchsize

#CUDA_VISIBLE_DEVICES=$gpu_num python train.py -data ../thumt_data/data/zh2en.eighty -save_model ./zh2en_model_$batchsize/model -gpu_ranks 0 \
#        -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
#        -encoder_type transformer -decoder_type transformer -position_encoding \
#        -train_steps 300000 -max_generator_batches 32 -dropout 0.1 \
#        -batch_size $batchsize -batch_type tokens -normalization tokens -accum_count 4 \
#        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
#        -max_grad_norm 0 -param_init 0 -param_init_glorot -report_every 100 \
#        -label_smoothing 0.1 -valid_steps 2000 -save_checkpoint_steps 2000 \
#        -log_file ./zh2en_model_$batchsize/log.txt > ./zh2en_model_$batchsize/ppl_acc.txt 

CUDA_VISIBLE_DEVICES=$gpu_num python train.py -data ../thumt_data/data/zh2en.eighty -save_model ./zh2en_model_$batchsize/model -gpu_ranks 0 \
        -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
        -encoder_type transformer -decoder_type transformer -position_encoding \
        -train_steps 300000 -max_generator_batches 32 -dropout 0.1 \
        -batch_size $batchsize -batch_type tokens -normalization tokens -accum_count 4 \
        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
        -max_grad_norm 0 -param_init 0 -param_init_glorot -report_every 100 \
        -label_smoothing 0.1 -valid_steps 2000 -save_checkpoint_steps 2000 \
        -log_file ./zh2en_model_$batchsize/log.txt > ./zh2en_model_$batchsize/ppl_acc.txt 

