#! /bin/bash

#Tool dependencies: identify, librsvg (rsvg-convert), zip

######################
# Stencil properties #
######################
stencil_id='open-iconic'
stencil_displayName='Open Iconic'
stencil_author='Icons: Open-Iconic; Pencil Stencil packaging: An7ar35'
stencil_description='Open Iconic icon set stencil package (https://github.com/iconic/open-iconic)'
stencil_url='https://github.com/An7ar35/open-iconic-for-pencil'

#################
# XML templates #
#################
header='<Shapes xmlns="http://www.evolus.vn/Namespace/Pencil"
    xmlns:p="http://www.evolus.vn/Namespace/Pencil"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"

    id="%s"
    displayName="%s"
    description="%s"
    author="%s"
    url="%s">

    <Properties>
        <PropertyGroup>
        <Property name="fillColor" displayName="Icon color" type="Color">#000000ff</Property>
        </PropertyGroup>
    </Properties>
    <Script>
        <!-- Shared script code for your collection -->
    </Script>

    <!-- Shape and shortcut definitions -->\n'  
  
shape='     <Shape id="%s" displayName="%s" icon="%s">
        <Properties>
            <PropertyGroup>
                <Property name="box" type="Dimension" p:lockRatio="true">%s,%s</Property>
            </PropertyGroup>
            <PropertyGroup name="Background">
                <Property name="fillColor" displayName="Color" type="Color">
                    <E>$$fillColor</E>
                </Property>
            </PropertyGroup>
        </Properties>
        <Behaviors>
            <For ref="icon">
                <Transform>scale($box.w/%s, $box.h/%s)</Transform>
                <Fill>$fillColor</Fill>
            </For>
            <For ref="bgRect">
                <Box>$box</Box>
            </For>
        </Behaviors>
        <p:Content xmlns:p="http://www.evolus.vn/Namespace/Pencil" xmlns="http://www.w3.org/2000/svg">
            <rect id="bgRect" style="fill: #000000; fill-opacity: 0; stroke: none;" x="0" y="0" />
            <g id="icon">
                <path%s/>
            </g>
        </p:Content>
    </Shape>\n'

footer='</Shapes>\n'

############################
# Creating build directory #
############################
icon_build_path="icons"
if [ ! -d 'build' ]; then
  mkdir -p build/$icon_build_path
fi

############################################################
# Processing and Printing the constructed XML stencil file #
############################################################
echo Building \"Definition.xml\"...
files_SVG=(open-iconic/svg/*)

printf "$header" "$stencil_id" "$stencil_displayName" "$stencil_description" "$stencil_author" "$stencil_url" >> build/Definition.xml

counter=0
echo -ne 'Generating shape '[${counter}'/'${#files_SVG[@]}']\r'     #progress (start)

for i in "${files_SVG[@]}"; do
    name=$(basename "$i" ".svg")                                    #extract core name from path
    png_name=$name'.png'
    
    counter=$((counter+1))
    echo -ne 'Generating shape ['${counter}'/'${#files_SVG[@]}']\r' #progress++
    
    rsvg-convert $i -w 24 -o build/$icon_build_path/$png_name       #create a png out of the svg
    
    shape_name=$png_name
    shape_id=${name}
    shape_icon=$icon_build_path/$png_name
    
    svg_width=$(identify -format '%w' $i)                           #get width of SVG
    svg_height=$(identify -format '%h' $i)                          #get height of SVG
    
    svg_dump=$(cat $i)                                              #grabbing content of SVG file
    svg_content=$(grep -oPm1 "(?<=<path)[^/>]+" <<< "$svg_dump")    #getting SVG data in path tag
     
    printf "$shape" "$shape_id" "$shape_name" "$shape_icon" "$svg_width" "$svg_height" "$svg_width" "$svg_height" "$svg_content" >> build/Definition.xml
done

echo -ne 'Generating shape ['${counter}'/'${#files_SVG[@]}']'       #progress (end)

printf "$footer" >> build/Definition.xml

################################
# Zip definition XML and icons #
################################
printf "\nPackaging stencil..."
cd build
zip -r ../open-iconic-stencil.zip * > /dev/null                     #zipping stencil
rm -r ../build                                                      #cleanup
printf "\nDone.\n"
