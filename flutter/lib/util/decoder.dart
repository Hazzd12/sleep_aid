

List<int> Decoder(List<int> val){
  List<int> result = [];
  if(val[0] == 0) {
    result.add(0);
    return result;
  }
  else{
    result.add(1);
  }
  return result;
}


List<int> realTimeData(List<int> val){
  List<int> result = [];
  if(val[2]==1||val[2]==2) {
    result.add(val[2]);
  }
  else{
    result[0] = 0;
    return result;
  }
  if(val[3]==1||val[3]==2){
    result.add(val[3]);
    return result;
  }
  else{
    result[0] = 0;
  }
  if(val[4]>=0&&val[4] <= 3){
    result.add(val[4]);
  }
  else{
    result[0] = 0;
    return result;
  }
  if(val[5]>=0){
    result.add(val[5]);
  }
  else{
    result[0] = 0;
    return result;
  }
  return result;
}