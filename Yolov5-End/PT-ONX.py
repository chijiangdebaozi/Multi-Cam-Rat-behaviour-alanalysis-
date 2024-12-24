import pathlib
temp = pathlib.PosixPath
pathlib.PosixPath = pathlib.WindowsPath

 export.py --weights weights/egg.pt --include onnx --opset 12 --dynamic
