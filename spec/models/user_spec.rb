require "rails_helper"

RSpec.describe User, type: :model do
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is valid a first name, last name, email, and password" do
    user =
      build(
        :user,
        first_name: "Aaron",
        last_name: "Sumner",
        email: "tester@example.com",
        password: "dottle-nouveau-pavilion-tights-furze"
      )
    expect(user).to be_valid
  end

  it "is invalid without a first name" do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    user = build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "is invalid without an email address" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    create(:user, email: "tester@example.com")
    user = build(:user, email: "tester@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  # ユーザーのフルネームを⽂字列として返すこと
  it "returns a user's full name as a string" do
    user = build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end
end
