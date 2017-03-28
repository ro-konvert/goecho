WorkerScript.onMessage = function(m) {
    var request = new XMLHttpRequest()
    var reports = []
    var lastdate = 0
    request.open('GET', "https://api.vk.com/api.php?oauth=1&method=wall.get&domain="+m.domain.name+"&count="+m.count)
    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE)
        {
            if (request.status && request.status === 200)
            {
                var result = JSON.parse(request.responseText).response
                result.reverse()
                var i = 0
                for(i = 0; i < result.length; i++)
                {
                    if(result[i].text)
                    {
                        result[i].text = result[i].text.replace(/(ftps?:\/\/|https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,20})([\/\%\w\s\.-]*)*\/?/g, '')
                        result[i].text = result[i].text.replace(/^(<br>)+|^\s+|\s+$|(<br>)+$/gm, '')
                        result[i].text = result[i].text.replace(/(<br>\s*)+|(<br \/>\s*)+/g, '<br>')
                    }
                }
                if(!m.unixtime)
                {
                    m.unixtime = 0
                }
                for(i = 0; i < result.length; i++)
                {
                    if(m.unixtime < result[i].date)
                    {
                        if (result.hasOwnProperty(i))
                        {
                            if(result[i].text)
                            {
                                if(!result[i].is_pinned)
                                {
                                    var attachments = null
                                    if (result[i].attachments)
                                    {
                                        attachments = result[i].attachments[0].type
                                    }
                                    if(!attachments || attachments === "photo" || attachments === "link")
                                    {
                                        var regular = result[i].text.match(m.domain.regular)
                                        if(regular)
                                        {
                                            var color = "#000000"
                                            if(m.isnext)
                                            {
                                                color = "#ff0000"
                                            }
                                            var date = new Date(result[i].date*1000)
                                            var monthNames = [qsTr("Январь"), qsTr("Февраль"), qsTr("Март"),
                                                              qsTr("Апрель"), qsTr("Май"), qsTr("Июнь"), qsTr("Июль"),
                                                              qsTr("Август"), qsTr("Сентябрь"), qsTr("Октябрь"),
                                                              qsTr("Ноябрь"), qsTr("Декабрь")]
                                            var day = date.getDate();
                                            var monthIndex = date.getMonth();
                                            var year = date.getFullYear();
                                            var  formattedDate = day + ', ' + monthNames[monthIndex] + ' ' + year
                                            result[i].text = '<b>'+m.domain.title+' ['+formattedDate+']'
                                                    +'</b><br>'+result[i].text
                                            reports.unshift({"rtext":result[i].text,
                                                                "rcolor":color,
                                                                "domain":m.domain.name,
                                                                "unixtime":result[i].date})
                                        }
                                    }
                                    lastdate = result[i].date
                                }
                            }
                        }
                    }
                }
                if(reports.length > 0)
                {
                    WorkerScript.sendMessage({'reports':reports})
                }
                else if(lastdate > 0)
                {
                    WorkerScript.sendMessage({'lastpost':{'lastdate':lastdate, 'domain':m.domain.name}})
                }
                else {
                    WorkerScript.sendMessage({'repeat':true})
                }
            }
            else
            {
                WorkerScript.sendMessage({'error':200})
            }
        }
    }
    request.send()
}

function sortReport(rModel)
{
    var i, j
    for(i = 0; i < rModel.count; i++)
    {
        for(j = i+1; j < rModel.count; j++)
        {
            if(rModel.get(i).unixtime < rModel.get(j).unixtime)
            {
                rModel.move(j, i, 1);
                i = 0;
            }
        }
    }
}

function removeReport(rModel, maxCount)
{
    if(rModel.count > maxCount)
    {
        rModel.remove(maxCount, rModel.count - maxCount)
    }
}
