require "spec_helper"

context "after provision finishes" do
  describe server(:es1) do
    describe http("http://localhost:9200/_cluster/health", inflate_gzip: true) do
      it "responds with 200" do
        expect(response.status).to eq 200
      end
      it "response is text/plain" do
        expect(response.headers["content-type"]).to match(%r{application/json})
      end

      it "shows the test cluster status is green" do
        expect(json_body_as_hash).to include("status" => "green")
      end

      it "shows node.total is 3" do
        expect(json_body_as_hash).to include("number_of_nodes" => 3)
      end
      it "shows node.data is 3" do
        expect(json_body_as_hash).to include("number_of_data_nodes" => 3)
      end
    end
  end
end

context "when a cluster is formed" do
  describe server(:es1) do
    it "is killed" do
      current_server.ssh_exec "sudo service elasticsearch stop"
      result = current_server.ssh_exec "sudo service elasticsearch status"
      expect(result).to match(Regexp.escape("elasticsearch not running? (check /var/run/elasticsearch.pid)."))
    end
  end
end

context "when the initial master is killed" do
  describe server(:es2) do
    describe http("http://localhost:9200/_cluster/health", inflate_gzip: true) do
      it "shows node.total is 2" do
        expect(json_body_as_hash).to include("number_of_nodes" => 2)
      end
      it "shows node.data is 2" do
        expect(json_body_as_hash).to include("number_of_data_nodes" => 2)
      end
    end

    describe http("http://localhost:9200/_cluster/state", inflate_gzip: true) do
      it "returns master_node" do
        @master_uuid = json_body_as_hash["master_node"]
        expect(@master_uuid).to match(/^\S+$/)
        @master_hostname = json_body_as_hash["nodes"][@master_uuid]["name"].split(".").first
      end
    end
  end
end

context "when the failover is successful" do
  describe server(:es1) do
    it "starts ES" do
      current_server.ssh_exec "sudo service elasticsearch start"
      result = current_server.ssh_exec "sudo service elasticsearch status"
      expect(result).to match(/elasticsearch is running as pid \d+\./)
      sleep 30 # wait long enough for the service to start
    end
  end
end

context "when the initial master is back" do
  describe server(:es1) do
    describe http("http://localhost:9200/_cluster/health", inflate_gzip: true) do
      it "shows the test cluster status is green" do
        expect(json_body_as_hash).to include("status" => "green")
      end

      it "shows it has re-joined to the cluster " do
        expect(json_body_as_hash).to include("number_of_nodes" => 3)
        expect(json_body_as_hash).to include("number_of_data_nodes" => 3)
      end
    end
  end
end
