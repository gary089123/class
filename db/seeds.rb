# 先清空 rents table 再下 rake db:seed
# users table 記得備份

require 'rest-client'
require 'json'

api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

# loop 4.5.6
for classroom_facility_id in 4..6

# api
base_url = 'http://140.115.3.188/facility/v1/facility/'
id = classroom_facility_id.to_s
from = '2014-09-26T00:00:00Z'
to = '2016-10-30T00:00:00Z'
limit = '2147483647'
url = base_url + id + '/rent?from=' + from + '&to=' + to + '&limit=' + limit
api = RestClient.get url, { 'X-NCU-API-TOKEN' => api_token }

# data in ruby array
jdoc = JSON.parse(api)
# examples
# puts "Hello #{jdoc["rents"][1].fetch("creator")}!"
# puts jdoc["rents"]
# puts jdoc["rents"][1].fetch("creator")
# puts jdoc["rents"][1].fetch("creator").fetch("name")
# puts jdoc["rents"][1].fetch("spans")[0].fetch("start")

# loop every rent
data = jdoc["rents"]
data.each do |q|
  rent = Rent.new

  # 事由
  rent.name = q.fetch("name")

  # 教室id
  rent.facility = classroom_facility_id

  # 時間
  # rent.start = q.fetch("spans")[0].fetch("start")
  # rent.end = q.fetch("spans")[0].fetch("end")
  q.fetch("spans").each do |qq|
    rent.start = qq.fetch("start")
    rent.end = qq.fetch("end")
  end

  # 對應使用者
  users = User.all
  users.each do |user|
    if user.name == q.fetch("creator").fetch("name")
      rent.user_id = user.id
    end
  end

  # 借用的狀態
  rent.status = "待審核"
  if q.fetch("verified")
    rent.status = "已借出"
  end

  # 記起來修改跟刪除的rent_id
  rent.apid = q.fetch("id")
  rent.save
end

end
