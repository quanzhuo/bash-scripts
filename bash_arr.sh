# This file illustrates how to use array in bash
# The code snippet is taken from aosp/build/envsetup.sh

unset LUNCH_MENU_CHOICES

function add_lunch_combo()
{
    local new_combo=$1
    local c

    for c in ${LUNCH_MENU_CHOICES[@]}; do
	if [ "$new_combo" = "$c" ]; then
	    return
	fi
    done
    
    # use "()" to define a array
    LUNCH_MENU_CHOICES=(${LUNCH_MENU_CHOICES[@]} $new_combo)
}

add_lunch_combo aosp_arm-eng
add_lunch_combo aosp_arm64-eng
add_lunch_combo aosp_mips-eng
add_lunch_combo aosp_mips64-eng
add_lunch_combo aosp_x86-eng
add_lunch_combo aosp_x86_64-eng

echo ${LUNCH_MENU_CHOICES[@]}
