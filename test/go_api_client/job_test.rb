require "test_helper"

module GoApiClient
  class JobTest < Test::Unit::TestCase
    test "should fetch the job xml and populate itself" do
      stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))

      link = "http://localhost:8153/go/api/jobs/1.xml"
      job = GoApiClient::Job.from(link)

      assert_equal 'http://localhost:8153/go/api/jobs/1.xml', job.url
      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test', job.artifacts_uri
      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test/cruise-output/console.log', job.console_log_url


      assert_equal 'urn:x-go.studios.thoughtworks.com:job-id:defaultPipeline:1:Units:1:Test', job.identifier

      assert_equal 900, job.duration
      assert_equal "Failed", job.result
      assert_equal Time.parse('2012-02-23 11:46:15 UTC'), job.scheduled
      assert_equal Time.parse('2012-02-23 11:46:27 UTC'), job.assigned
      assert_equal Time.parse('2012-02-23 11:46:37 UTC'), job.preparing
      assert_equal Time.parse('2012-02-23 11:46:41 UTC'), job.building
      assert_equal Time.parse('2012-02-23 11:46:42 UTC'), job.completing
      assert_equal Time.parse('2012-02-23 11:46:45 UTC'), job.completed
    end

    test "should parse job even when some properties are missing" do
      stub_request(:get, "http://go-server.1.project:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_with_no_properties.xml"))
      link = "http://go-server.1.project:8153/go/api/jobs/1.xml"
      job = GoApiClient::Job.from(link)

      assert_equal 80, job.duration
      assert_equal "Failed", job.result
      %w(scheduled assigned preparing building completing completed).each do |property|
        assert_nil job.send(property)
      end
    end

  end
end
