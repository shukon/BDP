import csv

with open('laendercodes.csv', 'r') as csvfile, open('reactionscript.js', 'w') as react:
    reader = csv.reader(csvfile, delimiter=',')
    react.write("module.exports = function (robot) {\n")
    for row in reader:
        print(row)
        react.write("""
robot.hear(/%s/i, function (res) {
    robot.adapter.callMethod('setReaction', ':flag_%s:', res.message.id).then(function(response) {
        console.log(response);
    });
});
 """ % (row[1], row[0].lower()))
    react.write("};")
