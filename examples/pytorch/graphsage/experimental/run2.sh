#/usr/bin/bash

echo "Slurm nodelist"
echo $SLURM_JOB_NODELIST
nodes=$1
#sh run_dist.sh -n $nodes -ppn 1 -f $HOSTFILE python train_dist_sym.py --dataset cora --n-epochs 200
#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym.py --dataset pubmed --n-epochs 200 --nr 5 --ru --version 4
#####--lr 0.04

#lr_arr=(0.001 0.002 0.003 0.005 0.006 0.008 0.01 0.02 0.03 0.05 0.08)
#lr_arr=(0.01 0.02 0.03 0.05 0.08)
#lr_arr=(0.01)

lr_arr=(0.01)
nr_arr=(1)
nepochs=200
dataset=reddit 
#exec_file=train_dist_sym2.py ## w/o dist inference and dist_bn 
exec_file=train_dist_sym2bn.py ## w/ dist inference and dist_bn
#dataset=ogbn-products
#exec_file=train_dist_sym_ogb.py
echo "Dataset: "$dataset
echo "exec_file: "$exec_file
for lr in ${lr_arr[@]}
do
    for nr in ${nr_arr[@]}
    do
        echo "lr: "$lr
        echo "nr check: "$nr
        sh run_dist.sh -n $nodes -ppn 2  python $exec_file --dataset $dataset \
           --n-epochs $nepochs \
           --lr  $lr \
           --nr 0 \
           --dl 0 \
           --dropout 0.50 \
           --aggregator-type gcn
        ##--val 
    done
done




#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym.py --dataset reddit --n-epochs 2 --nr 1 --lr  0.01 --val

