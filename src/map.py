from pyecharts.charts import Geo
from pyecharts import options as opts
from pyecharts.globals import GeoType
from scipy.io import loadmat
import numpy as np

data = loadmat('data.mat')
data = data['data']
datapair = []
g = Geo().add_schema(maptype='美国')
for i in range(data.shape[0]):
    g.add_coordinate(str(i+1), longitude=data[i][33], latitude=data[i][32])
    datapair.append((str(i+1), i))
g.add("geo", datapair, symbol_size=5)
g.set_series_opts(label_opts=opts.LabelOpts(is_show=False))
g.render()
