#/usr/bin/bash

echo "Slurm nodelist"
echo $SLURM_JOB_NODELIST
nodes=$1
#sh run_dist.sh -n $nodes -ppn 1 -f $HOSTFILE python train_dist_sym.py --dataset cora --n-epochs 200
#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym.py --dataset pubmed --n-epochs 200 --nr 5 --ru --version 4
#####--lr 0.04

#lr_arr=(0.001 0.002 0.003 0.005 0.006 0.008 0.01 0.02 0.03 0.05 0.08)
#lr_arr=(0.0075 0.005 0.003 0.001, 0.05)


lr_arr=(0.01)
#nr_arr=(1 2 3 4 5)
nr_arr=(0)
nepochs=300

#dataset=reddit
#exec_file=train_dist_sym2.py     ##-- unique training nodes
#exec_file=train_dist_sym_ogb3.py ##-- full graph & partitioned train set.
#exec_file=train_dist_sym_ogb4.py ##-- uses paritions in local folder, same as original
#exec_file=train_dist_sym_ogb5.py ##-- ext of 4 with mean_custom and added loss_grad_sync in sageconv
dataset=ogbn-products
exec_file=train_dist_sym_ogb5.py
echo "Dataset: "$dataset
echo "exec_file: "$exec_file

echo "BREAK"
echo "Dataset: "$dataset
echo "exec_file: "$exec_file
for lr in ${lr_arr[@]}
do
    for nr in ${nr_arr[@]}
    do
        echo "lr check: "$lr
        echo "nr check: "$nr
        sh run_dist.sh -n $nodes -ppn 2  python $exec_file --dataset $dataset \
           --n-epochs $nepochs \
           --lr  $lr \
           --nr 0 \
           --dl 0 \
           --dropout 0.50 \
           --aggregator-type mean  
        ##--val 
    done
done


#for lr in ${lr_arr[@]}
#do
#    for nr in ${nr_arr[@]}
#    do
#        echo "lr check: "$lr
#        echo "nr check: "$nr
#        sh run_dist.sh -n $nodes -ppn 2  python $exec_file --dataset $dataset \
#           --n-epochs $nepochs \
#           --lr  $lr \
#           --nr $nr \
#           --dropout 0.80 \
#           --aggregator-type mean \
#           --val 
#    done
#done



#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym.py --dataset reddit --n-epochs 2 --nr 1 --lr  0.01 --val

#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym.py --dataset cora --n-epochs 200  --val --nr 5 --aggregator-type "gcn"

#sh run_dist.sh -n $nodes -ppn 2  python train_dist_sym_ogb.py --dataset ogbn-products --n-epochs 300  --nr 1 --aggregator-type "gcn" --lr 0.03

