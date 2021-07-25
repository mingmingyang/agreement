#CUDA_VISIBLE_DEVICES=3 python train.py -data data/data -save_model /test_model -world_size 1 -gpu_ranks 0 -rnn_size 100 -word_vec_size 50 -layers 1 -train_steps 100 -optim adam -learning_rate 0.001
gpu_num=0
batchsize=2
accumcount=1
#model_path=zh2en_model_${accumcount}_${batchsize}_nobpe
model_from_path=./test_model/model_step_2000.pt
model_path=test_from_model
mkdir ${model_path}

CUDA_VISIBLE_DEVICES=$gpu_num python train.py -data data/data -save_model ./${model_path}/model -gpu_ranks 0 \
        -train_from $model_from_path -reset_optim all \
        -layers 6 -rnn_size 512 -word_vec_size 512 -transformer_ff 2048 -heads 8  \
        -encoder_type transformer -decoder_type transformer -position_encoding -keep_grad \
        -train_steps 10000 -max_generator_batches 16 -dropout 0.1 \
        -batch_size $batchsize -batch_type sents -normalization sents -accum_count $accumcount \
        -optim adam -adam_beta2 0.998 -decay_method noam -warmup_steps 4000 -learning_rate 2 \
        -max_grad_norm 0 -param_init 0 -param_init_glorot -report_every 100 \
        -label_smoothing 0.1 -valid_steps 2000 -save_checkpoint_steps 2000 \
        -log_file ./${model_path}/log.txt > ./${model_path}/ppl_acc.txt 
#
