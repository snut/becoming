# https://blender.stackexchange.com/questions/62980/export-every-object-into-separate-files

import bpy

def export_all_fbx(exportFolder):
    objects = bpy.data.objects
    for object in objects:
        bpy.ops.object.select_all(action='DESELECT')
        object.select_set(state=True)
        exportName = exportFolder + object.name + '.obj'
        bpy.ops.export_scene.obj(filepath=exportName, use_selection=True)

# export_all_fbx('C:\\outputFolder\\')
