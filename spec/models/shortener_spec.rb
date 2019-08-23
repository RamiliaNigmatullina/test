describe Shortener do
  let(:shortener) { described_class.new(string, options) }
  let(:string) { "abcdab987612" }
  let(:options) { {} }

  describe "#shorted_string" do
    subject(:shorted_string) { shortener.shorted_string }

    it { is_expected.to eq("a-dab9-612") }

    context "with random string" do
      let(:string) { "dkewklmnomewfm" }

      it { is_expected.to eq("dkewk-omewfm") }
    end

    context "with different symbols" do
      let(:string) { "?@ABCxyz{|}" }

      it { is_expected.to eq("?@A-Cx-z{|}") }
    end

    context "with digits range" do
      let(:string) { "1234567890" }

      it { is_expected.to eq("1-90") }
    end

    context "with one letters range" do
      let(:string) { "abcde" }

      it { is_expected.to eq("a-e") }
    end

    context "with empty string" do
      let(:string) { "" }

      it { is_expected.to eq("") }
    end

    context "with letters in different case" do
      let(:string) { "Abcd829MlK" }

      it { is_expected.to eq("A-d829M-K") }

      context "with case sensitive option" do
        let(:options) { { case_sensitive: true } }

        it { is_expected.to eq("Ab-d829MlK") }
      end
    end
  end
end
