for replication in 1 2 3 4; do
  for blocksize in 16640000 33280000 99840000 ; do
    for dimension in 200000000 300000000 400000000 500000000; do
      for percentage in 0.5 0.05; do
        echo $(printf "Running test with: \n%s %s %s %s" $replication $blocksize $dimension $percentage) >> log_test.txt
        ./run_test.sh $replication $blocksize $dimension $percentage
      done;
    done;
  done;
done;
      
