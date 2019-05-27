function cleanParams(datas) {
    var new_datas = {}
    for(var item in datas) {
        if(datas[item] instanceof  Array) {
            new_datas[item] = []
        }
        else if(Object.prototype.toString.call(datas[item]) === "[object Array]") {
            new_datas[item] = {}
        }
        else {
            new_datas[item] = ""
        }
    }
    return new_datas
}