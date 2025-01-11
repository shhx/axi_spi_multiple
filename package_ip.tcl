# Define project structure
set ip_name "axi_spi_multiple"
set ip_version "1.0"
set project_dir [pwd]
set hdl_dir "$project_dir/hdl"
set tb_dir "$project_dir/tb"
set regs_dir "$project_dir/regs"
set xgui_dir "$project_dir/xgui"
# set output_dir "$project_dir/$ip_name"
set output_dir "$project_dir"

# Create the IP core project
puts "Creating IP core project..."
create_project $ip_name $output_dir -part xc7z020clg400-1 -force
set_property "target_language" "VHDL" [current_project]

# Add source files
puts "Adding HDL source files..."
add_files -norecurse [glob -nocomplain $hdl_dir/*.vhd]

# Add testbench files (optional)
if {[file exists $tb_dir]} {
    puts "Adding testbench files..."
    add_files -norecurse [glob -nocomplain $tb_dir/*.vhd]
}
import_files -fileset sources_1 ./component.xml

# Define the top module
set_property "top" "spi_top" [current_fileset]

# Package the IP
puts "Packaging the IP..."
ipx::open_ipxact_file $project_dir/component.xml
set_property version $ip_version [ipx::current_core]

# Update checksums and save
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]

# Cleanup and finish
puts "IP core packaged successfully: $ip_name $ip_version"
close_project
# exit
