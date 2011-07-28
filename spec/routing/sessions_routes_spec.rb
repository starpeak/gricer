require 'spec_helper'

describe 'routes for session stats' do
  it { gricer_sessions_agent_name_process_path.should == '/gricer/sessions/agent_name_process' }
  it { { get: '/gricer/sessions/agent_name_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.name') }
  it { gricer_sessions_agent_name_spread_path.should == '/gricer/sessions/agent_name_spread' }
  it { { get: '/gricer/sessions/agent_name_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.name') }

  it { gricer_sessions_agent_os_process_path.should == '/gricer/sessions/agent_os_process' }
  it { { get: '/gricer/sessions/agent_os_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.os') }
  it { gricer_sessions_agent_os_spread_path.should == '/gricer/sessions/agent_os_spread' }
  it { { get: '/gricer/sessions/agent_os_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.os') }

  it { gricer_sessions_agent_full_version_process_path.should == '/gricer/sessions/agent_full_version_process' }
  it { { get: '/gricer/sessions/agent_full_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.full_version') }
  it { gricer_sessions_agent_full_version_spread_path.should == '/gricer/sessions/agent_full_version_spread' }
  it { { get: '/gricer/sessions/agent_full_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.full_version') }

  it { gricer_sessions_agent_major_version_process_path.should == '/gricer/sessions/agent_major_version_process' }
  it { { get: '/gricer/sessions/agent_major_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.major_version') }
  it { gricer_sessions_agent_major_version_spread_path.should == '/gricer/sessions/agent_major_version_spread' }
  it { { get: '/gricer/sessions/agent_major_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.major_version') }

  it { gricer_sessions_agent_engine_name_process_path.should == '/gricer/sessions/agent_engine_name_process' }
  it { { get: '/gricer/sessions/agent_engine_name_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.engine_name') }
  it { gricer_sessions_agent_engine_name_spread_path.should == '/gricer/sessions/agent_engine_name_spread' }
  it { { get: '/gricer/sessions/agent_engine_name_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.engine_name') }

  it { gricer_sessions_agent_engine_version_process_path.should == '/gricer/sessions/agent_engine_version_process' }
  it { { get: '/gricer/sessions/agent_engine_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'agent.engine_version') }
  it { gricer_sessions_agent_engine_version_spread_path.should == '/gricer/sessions/agent_engine_version_spread' }
  it { { get: '/gricer/sessions/agent_engine_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.engine_version') }

  it { gricer_sessions_javascript_process_path.should == '/gricer/sessions/javascript_process' }
  it { { get: '/gricer/sessions/javascript_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'javascript') }
  it { gricer_sessions_javascript_spread_path.should == '/gricer/sessions/javascript_spread' }
  it { { get: '/gricer/sessions/javascript_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'javascript') }

  it { gricer_sessions_java_process_path.should == '/gricer/sessions/java_process' }
  it { { get: '/gricer/sessions/java_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'java') }
  it { gricer_sessions_java_spread_path.should == '/gricer/sessions/java_spread' }
  it { { get: '/gricer/sessions/java_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'java') }

  it { gricer_sessions_silverlight_version_process_path.should == '/gricer/sessions/silverlight_version_process' }
  it { { get: '/gricer/sessions/silverlight_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'silverlight_version') }
  it { gricer_sessions_silverlight_version_spread_path.should == '/gricer/sessions/silverlight_version_spread' }
  it { { get: '/gricer/sessions/silverlight_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'silverlight_version') }

  it { gricer_sessions_silverlight_major_version_process_path.should == '/gricer/sessions/silverlight_major_version_process' }
  it { { get: '/gricer/sessions/silverlight_major_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'silverlight_major_version') }
  it { gricer_sessions_silverlight_major_version_spread_path.should == '/gricer/sessions/silverlight_major_version_spread' }
  it { { get: '/gricer/sessions/silverlight_major_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'silverlight_major_version') }

  it { gricer_sessions_flash_version_process_path.should == '/gricer/sessions/flash_version_process' }
  it { { get: '/gricer/sessions/flash_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'flash_version') }
  it { gricer_sessions_flash_version_spread_path.should == '/gricer/sessions/flash_version_spread' }
  it { { get: '/gricer/sessions/flash_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'flash_version') }

  it { gricer_sessions_flash_major_version_process_path.should == '/gricer/sessions/flash_major_version_process' }
  it { { get: '/gricer/sessions/flash_major_version_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'flash_major_version') }
  it { gricer_sessions_flash_major_version_spread_path.should == '/gricer/sessions/flash_major_version_spread' }
  it { { get: '/gricer/sessions/flash_major_version_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'flash_major_version') }

  it { gricer_sessions_country_process_path.should == '/gricer/sessions/country_process' }
  it { { get: '/gricer/sessions/country_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'country') }
  it { gricer_sessions_country_spread_path.should == '/gricer/sessions/country_spread' }
  it { { get: '/gricer/sessions/country_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'country') }

  it { gricer_sessions_city_process_path.should == '/gricer/sessions/city_process' }
  it { { get: '/gricer/sessions/city_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'city') }
  it { gricer_sessions_city_spread_path.should == '/gricer/sessions/city_spread' }
  it { { get: '/gricer/sessions/city_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'city') }

  it { gricer_sessions_domain_process_path.should == '/gricer/sessions/domain_process' }
  it { { get: '/gricer/sessions/domain_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'domain') }
  it { gricer_sessions_domain_spread_path.should == '/gricer/sessions/domain_spread' }
  it { { get: '/gricer/sessions/domain_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'domain') }

  it { gricer_sessions_screen_size_process_path.should == '/gricer/sessions/screen_size_process' }
  it { { get: '/gricer/sessions/screen_size_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'screen_size') }
  it { gricer_sessions_screen_size_spread_path.should == '/gricer/sessions/screen_size_spread' }
  it { { get: '/gricer/sessions/screen_size_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_size') }

  it { gricer_sessions_screen_width_process_path.should == '/gricer/sessions/screen_width_process' }
  it { { get: '/gricer/sessions/screen_width_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'screen_width') }
  it { gricer_sessions_screen_width_spread_path.should == '/gricer/sessions/screen_width_spread' }
  it { { get: '/gricer/sessions/screen_width_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_width') }

  it { gricer_sessions_screen_height_process_path.should == '/gricer/sessions/screen_height_process' }
  it { { get: '/gricer/sessions/screen_height_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'screen_height') }
  it { gricer_sessions_screen_height_spread_path.should == '/gricer/sessions/screen_height_spread' }
  it { { get: '/gricer/sessions/screen_height_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_height') }

  it { gricer_sessions_screen_depth_process_path.should == '/gricer/sessions/screen_depth_process' }
  it { { get: '/gricer/sessions/screen_depth_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'screen_depth') }
  it { gricer_sessions_screen_depth_spread_path.should == '/gricer/sessions/screen_depth_spread' }
  it { { get: '/gricer/sessions/screen_depth_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_depth') }

  it { gricer_sessions_requested_locale_major_process_path.should == '/gricer/sessions/requested_locale_major_process' }
  it { { get: '/gricer/sessions/requested_locale_major_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'requested_locale_major') }
  it { gricer_sessions_requested_locale_major_spread_path.should == '/gricer/sessions/requested_locale_major_spread' }
  it { { get: '/gricer/sessions/requested_locale_major_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'requested_locale_major') }

  it { gricer_sessions_requested_locale_minor_process_path.should == '/gricer/sessions/requested_locale_minor_process' }
  it { { get: '/gricer/sessions/requested_locale_minor_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'requested_locale_minor') }
  it { gricer_sessions_requested_locale_minor_spread_path.should == '/gricer/sessions/requested_locale_minor_spread' }
  it { { get: '/gricer/sessions/requested_locale_minor_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'requested_locale_minor') }

  it { gricer_sessions_requested_locale_process_path.should == '/gricer/sessions/requested_locale_process' }
  it { { get: '/gricer/sessions/requested_locale_process'}.should route_to(controller: 'gricer/sessions', action: 'process_stats', field: 'requested_locale') }
  it { gricer_sessions_requested_locale_spread_path.should == '/gricer/sessions/requested_locale_spread' }
  it { { get: '/gricer/sessions/requested_locale_spread'}.should route_to(controller: 'gricer/sessions', action: 'spread_stats', field: 'requested_locale') }

 
end