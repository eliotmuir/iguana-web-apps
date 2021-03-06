
function bedmonitor.app.listBeds(Request)
   local DB = bedmonitor.db.connect()
   local Data = DB:query{sql="SELECT * FROM bed"}

   local Results = {aaData={}, aoColumns={}}
   Results.aoColumns = {
      {['sTitle'] = 'Bed', ['sType'] = 'string'},
      {['sTitle'] = 'Patient', ['sType'] = 'string'},
      {['sTitle'] = 'Condition', ['sType'] = 'string'}}
   
   for i=1, #Data do
      local Row = Data[i]
      local Name = getName(Row)
      local Condition = getCondition(Row)
      Results.aaData[i] = {Row.bed_name:S(), Name, Condition}
      json.serialize{data=Results.aaData[i],compact=true}
   end
   return Results
end

function getName(Row)
   if Row.patient_last_name:S() == "" then
      return "Unoccupied"
   else
      return Row.patient_last_name:S()..", "..Row.patient_first_name:S()
   end
end

function getCondition(Row)
   local Cond = Row.condition:S()
   if Cond == '' then 
      return "N/A" 
   else
      return Cond
   end
end
