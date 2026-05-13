clamp_width = 15;         
clamp_thickness = 1.5;      
clamp_height = 9;         
cylinder_diameter = 12.5; 
base_length = 18;         
base_thickness = 0.5;     
hole_diameter = 0.4;      
mount_hole_diameter = 0.5;
mount_hole_offset = 5.08; 
mount_hole_length = 4.8; 
mount_hole_width = 0.5;   

module end_clamp_with_half_base() {
    difference() {
        
        cube([clamp_thickness, clamp_width, clamp_height]);
        
       
        translate([clamp_thickness/2, clamp_width/2, clamp_height])
        rotate([0, 90, 0])
        cylinder(h = clamp_thickness, d = cylinder_diameter, center=true);
        
        
        for (y = [-hole_diameter, hole_diameter]) {
            translate([clamp_thickness/2, y + clamp_width/2, clamp_height/2])
            rotate([0, 90, 0])
            cylinder(h = clamp_thickness + 0.2, d = hole_diameter);
        }
    }
    
    
    translate([-base_length/2 + clamp_thickness/2, 0, -base_thickness])
    difference() {
        cube([base_length, clamp_width, base_thickness]);
        
        
        for (x = [-mount_hole_offset, mount_hole_offset]) {
            for (y = [-mount_hole_offset, mount_hole_offset]) {
                translate([x + base_length/2, y + clamp_width/2, -0.01])
                hull() {
                    translate([-mount_hole_length/2, 0, 0])
                    cylinder(h = base_thickness + 0.02, d = mount_hole_width);
                    
                    translate([mount_hole_length/2, 0, 0])
                    cylinder(h = base_thickness + 0.02, d = mount_hole_width);
                }
            }
        }

        
        translate([base_length/2 - 1, clamp_width/2, -0.15])
        linear_extrude(height = 0.3)
        text("L", size = 1.2, valign = "center", halign = "center");
    }
}


translate([0, 0, 0]) end_clamp_with_half_base();
