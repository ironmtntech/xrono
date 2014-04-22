SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :unentered_time_report, t(:unentered_time_report), admin_unentered_time_report_index_path, :highlights_on => /unentered_time_report/
    primary.item :weekly_time_report, t(:weekly_time_report), admin_weekly_time_report_index_path, :highlights_on => /weekly_time_report/
    primary.item :time_summary_report, t(:time_summary_report), admin_time_summary_report_index_path, :highlights_on => /time_summary_report/
  end
end
