# Set up arguments.
FILTER="filter-test.json"
MAPREDUCE="uitour"
VERBOSE=false

# Pull is a little more complicated, since we only want to do it if we have cached data.
if [ -d "/mnt/telemetry/work/cache/" ]; then
  PULL="--local-only"
else
  PULL=""
fi

# Parse the arguments, kinda.
while [[ $1 ]]; do
  case $1 in
    -f|--for-real)
      FILTER="filter.json"
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo "  -f, --for-real        Use the less-specific non-test filter."
      echo "  -h, --help            Show this help."
      echo "  -m, --map-reduce ARG  Specify which mapreduce file to use."
      echo "  -p, --pull-data       Force the program to skip the cache, and pull the data again."
      echo "  -v, --verbose         Show more info about what's happening'."
      exit 0
      ;;
    -m|--map-reduce)
      shift
      MAPREDUCE=$1
      ;;
    -p|--pull-data)
      PULL=""
      ;;
    -v|--verbose)
      VERBOSE=true
      ;;
    *)
      echo '--> '"\`$1'" ;
      ;;
  esac
  shift
done

if $VERBOSE; then
  echo python -m mapreduce.job ../$MAPREDUCE.py --input-filter ../$FILTER --num-mappers 16 --num-reducers 4 --data-dir /mnt/telemetry/work/cache --work-dir /mnt/telemetry/work --output /mnt/telemetry/my_mapreduce_results.out $PULL --bucket "telemetry-published-v1"
fi
python -m mapreduce.job ../$MAPREDUCE.py --input-filter ../$FILTER --num-mappers 16 --num-reducers 4 --data-dir /mnt/telemetry/work/cache --work-dir /mnt/telemetry/work --output /mnt/telemetry/my_mapreduce_results.out $PULL --bucket "telemetry-published-v1"
