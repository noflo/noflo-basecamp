readenv = require "../components/ConvertToJson"
socket = require('noflo').internalSocket

setupComponent = ->
  c = readenv.getComponent()
  ins = socket.createSocket()
  out = socket.createSocket()
  c.inPorts.in.attach ins
  c.outPorts.out.attach out
  [c, ins, out]

exports['test reading simple project'] = (test) ->
  [c, ins, out] = setupComponent()
  test.expect 2

  xml =
    id:
      '#': 2
    name: 'Shopping Cart Redesign'
    'start-page': 'log'
    status: 'active'
    'company-id': 123
    'created-on':
      '#': '2012-11-08'
    'last-changed-on':
      '#': '2012-11-08'

  out.once 'data', (data) ->
    test.equal data['@type'], 'prj:Project'
    test.equal data['prj:name'], 'Shopping Cart Redesign'
    test.done()
  ins.send xml
  do ins.disconnect
