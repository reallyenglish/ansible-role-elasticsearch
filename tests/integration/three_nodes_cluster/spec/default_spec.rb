require "spec_helper"

context "after provision finishes" do
  describe server(:es1) do
    describe http("http://localhost:9200/_cat/health", inflate_gzip: true) do
      it "responds with 200" do
        expect(response.status).to eq 200
      end
      it "response is text/plain" do
        expect(response.headers['content-type']).to match(/text\/plain/)
      end

      it "shows a single cluster" do
        expect(response.body.lines.length).to eq 1
      end

      it "shows the test cluster status is green" do
        expect(response.body.lines.first).to match(/\btest\s+green\b/)
      end

      it "shows node.total is 3" do
        # epoch timestamp cluster status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent 
        fields = response.body.lines.first.split(/\s+/)
        expect(fields[4].to_i).to eq 3
      end
      it "shows node.data is 3" do
        fields = response.body.lines.first.split(/\s+/)
        expect(fields[5].to_i).to eq 3
      end
    end
  end
end
