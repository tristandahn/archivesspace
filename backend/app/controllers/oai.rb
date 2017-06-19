require_relative '../lib/oai/aspace_oai_provider'

class ArchivesSpaceService < Sinatra::Base

  Endpoint.get('/oai')
    .description("Handle an OAI request")
    .params(["verb", String, "The OAI verb (Identify, ListRecords, GetRecord, etc.)"],
            ["metadataPrefix",
             String,
             "One of: " + ArchivesSpaceOAIRepository::AVAILABLE_RECORD_TYPES.keys.join(", "),
             :optional => true],
            ["from", String, "Start date (yyyy-mm-dd, yyyy-mm-ddThh:mm:ssZ)", :optional => true],
            ["until", String, "End date (yyyy-mm-dd, yyyy-mm-ddThh:mm:ssZ)", :optional => true],
            ["resumptionToken", String, "The OAI resumption token", :optional => true],
            ["set", String, "Requested OAI set (see ?verb=Identify for available sets)", :optional => true],
            ["identifier", String, "The requested record identifier (for ?verb=GetRecord)", :optional => true])
    .permissions([])            # No permissions because the endpoint is effectively public
    .returns([200, "OAI response"]) \
  do
    provider = ArchivesSpaceOaiProvider.new

    [200, {"Content-Type" => "text/xml"}, provider.process_request(params)]
  end

end
