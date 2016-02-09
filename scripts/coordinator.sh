for replication in 1 2 3 4; do
  for blocksize in 1048576 1572864 2097152; do
    for dimension in 200000000 300000000 400000000 500000000; do
      echo $(printf "Running test with: \n%s %s %s" $replication $blocksize $dimension) >> log_test.txt
      ./run_test.sh $replication $blocksize $dimension
    done;
  done;
done;
      
