require "rails_helper"

RSpec.describe Note, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project and message" do
    note =
      Note.new(message: "This is a sample note.", user: user, project: project)
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "search message for a term" do
    let!(:note1) do
      create(:note, message: "This is the first note.", user: user)
    end
    let!(:note2) do
      create(:note, message: "This is the second note.", user: user)
    end
    let!(:note3) do
      create(:note, message: "First, preheat the oven.", user: user)
    end

    context "when a match is found" do
      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(note1, note3)
        expect(Note.search("first")).to_not include(note2)
      end
    end

    context "when no match is found" do
      # 検索結果が1件も見つからなければ空のコレクションを返すこと
      it "returns an empty collection when no results are found" do
        expect(Note.count).to eq 3
        expect(Note.search("message")).to be_empty
      end
    end
  end

  it "delegates name to the user who created it" do
    user = instance_double("User", name: "Fake User")
    note = create(:note)
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end
end
