require "spec_helper"

[ :es1, :es2, :es3 ].each do |src|
  [ :es1, :es2, :es3 ].each do |dst|
    describe server(src) do
      describe firewall(server(dst)) do
        it { is_expected.to be_reachable }
      end
    end
  end
end
