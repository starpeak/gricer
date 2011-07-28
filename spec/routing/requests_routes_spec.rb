require 'spec_helper'

describe 'routes for request stats' do
  it { gricer_requests_agent_name_process_path.should == '/gricer/requests/agent_name_process' }
  it { { get: '/gricer/requests/agent_name_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.name') }
  it { gricer_requests_agent_name_spread_path.should == '/gricer/requests/agent_name_spread' }
  it { { get: '/gricer/requests/agent_name_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.name') }

  it { gricer_requests_agent_os_process_path.should == '/gricer/requests/agent_os_process' }
  it { { get: '/gricer/requests/agent_os_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.os') }
  it { gricer_requests_agent_os_spread_path.should == '/gricer/requests/agent_os_spread' }
  it { { get: '/gricer/requests/agent_os_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.os') }

  it { gricer_requests_agent_full_version_process_path.should == '/gricer/requests/agent_full_version_process' }
  it { { get: '/gricer/requests/agent_full_version_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.full_version') }
  it { gricer_requests_agent_full_version_spread_path.should == '/gricer/requests/agent_full_version_spread' }
  it { { get: '/gricer/requests/agent_full_version_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.full_version') }

  it { gricer_requests_agent_major_version_process_path.should == '/gricer/requests/agent_major_version_process' }
  it { { get: '/gricer/requests/agent_major_version_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.major_version') }
  it { gricer_requests_agent_major_version_spread_path.should == '/gricer/requests/agent_major_version_spread' }
  it { { get: '/gricer/requests/agent_major_version_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.major_version') }

  it { gricer_requests_agent_engine_name_process_path.should == '/gricer/requests/agent_engine_name_process' }
  it { { get: '/gricer/requests/agent_engine_name_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.engine_name') }
  it { gricer_requests_agent_engine_name_spread_path.should == '/gricer/requests/agent_engine_name_spread' }
  it { { get: '/gricer/requests/agent_engine_name_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.engine_name') }

  it { gricer_requests_agent_engine_version_process_path.should == '/gricer/requests/agent_engine_version_process' }
  it { { get: '/gricer/requests/agent_engine_version_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'agent.engine_version') }
  it { gricer_requests_agent_engine_version_spread_path.should == '/gricer/requests/agent_engine_version_spread' }
  it { { get: '/gricer/requests/agent_engine_version_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'agent.engine_version') }

  it { gricer_requests_host_process_path.should == '/gricer/requests/host_process' }
  it { { get: '/gricer/requests/host_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'host') }
  it { gricer_requests_host_spread_path.should == '/gricer/requests/host_spread' }
  it { { get: '/gricer/requests/host_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'host') }

  it { gricer_requests_path_process_path.should == '/gricer/requests/path_process' }
  it { { get: '/gricer/requests/path_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'path') }
  it { gricer_requests_path_spread_path.should == '/gricer/requests/path_spread' }
  it { { get: '/gricer/requests/path_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'path') }

  it { gricer_requests_method_process_path.should == '/gricer/requests/method_process' }
  it { { get: '/gricer/requests/method_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'method') }
  it { gricer_requests_method_spread_path.should == '/gricer/requests/method_spread' }
  it { { get: '/gricer/requests/method_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'method') }

  it { gricer_requests_protocol_process_path.should == '/gricer/requests/protocol_process' }
  it { { get: '/gricer/requests/protocol_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'protocol') }
  it { gricer_requests_protocol_spread_path.should == '/gricer/requests/protocol_spread' }
  it { { get: '/gricer/requests/protocol_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'protocol') }

  it { gricer_requests_entry_path_process_path.should == '/gricer/requests/entry_path_process' }
  it { { get: '/gricer/requests/entry_path_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'entry_path') }
  it { gricer_requests_entry_path_spread_path.should == '/gricer/requests/entry_path_spread' }
  it { { get: '/gricer/requests/entry_path_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'entry_path') }

  it { gricer_requests_referer_protocol_process_path.should == '/gricer/requests/referer_protocol_process' }
  it { { get: '/gricer/requests/referer_protocol_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'referer_protocol') }
  it { gricer_requests_referer_protocol_spread_path.should == '/gricer/requests/referer_protocol_spread' }
  it { { get: '/gricer/requests/referer_protocol_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'referer_protocol') }

  it { gricer_requests_referer_host_process_path.should == '/gricer/requests/referer_host_process' }
  it { { get: '/gricer/requests/referer_host_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'referer_host') }
  it { gricer_requests_referer_host_spread_path.should == '/gricer/requests/referer_host_spread' }
  it { { get: '/gricer/requests/referer_host_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'referer_host') }

  it { gricer_requests_referer_path_process_path.should == '/gricer/requests/referer_path_process' }
  it { { get: '/gricer/requests/referer_path_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'referer_path') }
  it { gricer_requests_referer_path_spread_path.should == '/gricer/requests/referer_path_spread' }
  it { { get: '/gricer/requests/referer_path_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'referer_path') }

  it { gricer_requests_referer_params_process_path.should == '/gricer/requests/referer_params_process' }
  it { { get: '/gricer/requests/referer_params_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'referer_params') }
  it { gricer_requests_referer_params_spread_path.should == '/gricer/requests/referer_params_spread' }
  it { { get: '/gricer/requests/referer_params_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'referer_params') }

  it { gricer_requests_search_engine_process_path.should == '/gricer/requests/search_engine_process' }
  it { { get: '/gricer/requests/search_engine_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'search_engine') }
  it { gricer_requests_search_engine_spread_path.should == '/gricer/requests/search_engine_spread' }
  it { { get: '/gricer/requests/search_engine_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'search_engine') }

  it { gricer_requests_search_query_process_path.should == '/gricer/requests/search_query_process' }
  it { { get: '/gricer/requests/search_query_process'}.should route_to(controller: 'gricer/requests', action: 'process_stats', field: 'search_query') }
  it { gricer_requests_search_query_spread_path.should == '/gricer/requests/search_query_spread' }
  it { { get: '/gricer/requests/search_query_spread'}.should route_to(controller: 'gricer/requests', action: 'spread_stats', field: 'search_query') }

 
end