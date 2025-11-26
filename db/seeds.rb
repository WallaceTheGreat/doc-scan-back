users = [
  {
    fname: "Wallace",
    lname: "The Great",
    username: "wallacethegreat",
    email: "wallace.dev@gmail.com", 
    password: "password123",
    password_confirmation: "password123"
  },
  {
    fname: "Gromit",
    lname: "The Dog",
    username: "gromitdog",
    email: "gromit.dev@gmail.com",
    password: "password123",
    password_confirmation: "password123"
  }
]

users.each do |user|
  User.create!(user)
end

documents = [
  {
    title: "doc1",
    created_by: 1,
    path: "doc1.jpg"
  },
  {
    title: "doc2",
    created_by: 2,
    path: "doc2.jpg"
  }
]

documents.each do |document|
  Document.create!(document)
end
