exe () {
  params="$@"                       # Put all of the command-line into "params"
  printf "\n%s\t$params\n" "$(date)"    # Print the command to the log file
  $params                           # Execute the command
}

            # tables=1 table_size=70000000 \
            # threads=256

# pk range
for range_type in simple_ranges sum_ranges order_ranges distinct_ranges; do
    for trx in on off; do
        exe env \
            events=1000000 \
            skip_trx=$trx \
            range_size=100 range_type=$range_type \
            ./oltp_pk_ranges.sh
    done
done

# point select
exe env \
     events=10000000 \
    ./oltp_point_select.sh

# read only
exe env \
    events=500000 \
    range_size=100 skip_trx=off \
    ./oltp_read_only.sh


# random points
for points in 10 100 1000; do
    exe env \
        events=$((10000000/points)) \
        random_points=$points  ./oltp_select_random_points.sh
done

# random ranges
total_data=$((10 * 1000))
for range_num in 1 5 10 50 100; do
    exe env \
        events=100000 \
        number_of_ranges=$range_num delta=$((total_data/range_num)) \
        ./oltp_select_random_ranges.sh
done

# update index
exe env \
    events=1000000 \
    ./oltp_update_index.sh

# update non_index
exe env \
    events=1000000 \
    ./oltp_update_non_index.sh
