'''
Created on December 7, 2011

@author: talbertc
'''
from core.modules.vistrails_module import Module
from PyQt4 import QtCore, QtGui
import csv
import utils
from utils import writetolog
import shutil
import os
from core.system import execute_cmdline
import subprocess
import glob

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s


class SelectAndTestFinalModel(QtGui.QDialog):

    def __init__(self, session_folder, rPath, parent=None):
        self.rPath = rPath
        self.session_folder = session_folder
        self.findModel = FindModelType(session_folder, parent)
        
        self.csv_file = self.findModel.csv_file
        self.display_jpeg = self.findModel.jpeg_file
        
        QtGui.QDialog.__init__(self, parent)      
        
        layout = QtGui.QVBoxLayout()
        self.setWindowFlags(QtCore.Qt.Window)
        ##begin  autogenerated code from QtDesigner
        #
        
        self.horizontalLayout_4 = QtGui.QHBoxLayout()
        self.horizontalLayout_4.setSpacing(5)
        self.horizontalLayout_4.setMargin(5)
        self.horizontalLayout_4.setObjectName(_fromUtf8("horizontalLayout_4"))
        self.verticalLayout_3 = QtGui.QVBoxLayout()
        self.verticalLayout_3.setObjectName(_fromUtf8("verticalLayout_3"))
        self.splitter = QtGui.QSplitter()
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.splitter.sizePolicy().hasHeightForWidth())
        self.splitter.setSizePolicy(sizePolicy)
        self.splitter.setMinimumSize(QtCore.QSize(0, 0))
        self.splitter.setFrameShape(QtGui.QFrame.Box)
        self.splitter.setFrameShadow(QtGui.QFrame.Plain)
        self.splitter.setLineWidth(1)
        self.splitter.setOrientation(QtCore.Qt.Horizontal)
        self.splitter.setHandleWidth(10)
        self.splitter.setObjectName(_fromUtf8("splitter"))
        self.widget = QtGui.QWidget(self.splitter)
        self.widget.setObjectName(_fromUtf8("widget"))
        self.verticalLayout = QtGui.QVBoxLayout(self.widget)
        self.verticalLayout.setSpacing(4)
        self.verticalLayout.setSizeConstraint(QtGui.QLayout.SetDefaultConstraint)
        self.verticalLayout.setContentsMargins(6, 6, 3, 3)
        self.verticalLayout.setObjectName(_fromUtf8("verticalLayout"))
        self.label_2 = QtGui.QLabel(self.widget)
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.verticalLayout.addWidget(self.label_2)
        self.treeview = QtGui.QTreeWidget(self.widget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Ignored, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.treeview.sizePolicy().hasHeightForWidth())
        self.treeview.setSizePolicy(sizePolicy)
        self.treeview.setMinimumSize(QtCore.QSize(75, 0))
        self.treeview.setMaximumSize(QtCore.QSize(16777215, 16777215))
        self.treeview.setSizeIncrement(QtCore.QSize(100, 0))
        self.treeview.setBaseSize(QtCore.QSize(0, 0))
        self.treeview.setObjectName(_fromUtf8("treeview"))
        self.verticalLayout.addWidget(self.treeview)
        self.horizontalLayout_3 = QtGui.QHBoxLayout()
        self.horizontalLayout_3.setSizeConstraint(QtGui.QLayout.SetDefaultConstraint)
        self.horizontalLayout_3.setObjectName(_fromUtf8("horizontalLayout_3"))
        self.btnRunR = QtGui.QPushButton(self.widget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Fixed, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.btnRunR.sizePolicy().hasHeightForWidth())
#        self.btnRunR.setSizePolicy(sizePolicy)
#        self.btnRunR.setObjectName(_fromUtf8("btnRunR"))
        self.horizontalLayout_3.addWidget(self.btnRunR)
        spacerItem = QtGui.QSpacerItem(10, 0, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout_3.addItem(spacerItem)

        
        self.verticalLayout.addLayout(self.horizontalLayout_3)
        
        self.scene = QtGui.QGraphicsScene() 
        self.view = QtGui.QGraphicsView(self.scene)
        #self.view = customGraphicsView(self.scene)
        self.view.setDragMode(QtGui.QGraphicsView.ScrollHandDrag)
        
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(4)
        sizePolicy.setVerticalStretch(0)
        self.view.setSizePolicy(sizePolicy)
        self.view.setResizeAnchor(QtGui.QGraphicsView.AnchorUnderMouse)
        self.view.setObjectName(_fromUtf8("view"))
        
        self.splitter.addWidget(self.view)
        
        self.verticalLayout_3.addWidget(self.splitter)
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setContentsMargins(-1, 3, -1, 3)
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.chkEvalHoldout = QtGui.QCheckBox()
        self.chkEvalHoldout.setText("Evaluate Hold Out")
        self.chkEvalHoldout.setObjectName(_fromUtf8('chkEvalHoldout'))
        self.lblProduceMaps = QtGui.QLabel()
        self.lblProduceMaps.setText("Produce maps")
        self.chkProb = QtGui.QCheckBox()
        self.chkProb.setText("Probability")
        self.chkProb.setObjectName(_fromUtf8('chkProb'))
        self.chkBin = QtGui.QCheckBox()
        self.chkBin.setText("Binary")
        self.chkBin.setObjectName(_fromUtf8('chkBin'))
        self.chkMess = QtGui.QCheckBox()
        self.chkMess.setText("MESS")
        self.chkMess.setObjectName(_fromUtf8('chkMess'))
        
        self.btnOK = QtGui.QPushButton()
        self.btnOK.setObjectName(_fromUtf8("btnOK"))
        self.btnOK.setText(_fromUtf8("OK"))
        self.btnCancel = QtGui.QPushButton()
        self.btnCancel.setText(_fromUtf8("Cancel"))
        self.btnCancel.setObjectName(_fromUtf8("btnCancel"))
        
        self.horizontalLayout.addWidget(self.chkEvalHoldout)
        self.horizontalLayout.addWidget(self.lblProduceMaps)
        self.horizontalLayout.addWidget(self.chkProb)
        self.horizontalLayout.addWidget(self.chkBin)
        self.horizontalLayout.addWidget(self.chkMess)
        self.horizontalLayout.addWidget(self.btnOK)
        self.horizontalLayout.addWidget(self.btnCancel)
        
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        
        
#        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Fixed, QtGui.QSizePolicy.Fixed)
#        sizePolicy.setHorizontalStretch(0)
#        sizePolicy.setVerticalStretch(0)
#        sizePolicy.setHeightForWidth(self.btnOK.sizePolicy().hasHeightForWidth())
#        self.btnOK.setSizePolicy(sizePolicy)
#        self.btnOK.setBaseSize(QtCore.QSize(100, 0))
#        self.btnOK.setToolTip(_fromUtf8(""))
        

        
        
#        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Fixed, QtGui.QSizePolicy.Fixed)
#        sizePolicy.setHorizontalStretch(0)
#        sizePolicy.setVerticalStretch(0)
#        sizePolicy.setHeightForWidth(self.btnCancel.sizePolicy().hasHeightForWidth())
#        self.btnCancel.setSizePolicy(sizePolicy)
#        self.btnCancel.setBaseSize(QtCore.QSize(100, 0))
        
        
        self.horizontalLayout_4.addLayout(self.verticalLayout_3)

        self.setWindowTitle(_fromUtf8("Evaluate Holdout data and/or produce maps"))
        self.label_2.setText(_fromUtf8("Models"))
#        self.btnRunR.setText(_fromUtf8("Run Final Test"))
#        self.label.setText(_fromUtf8("Threshold"))
        
        self.resize(1100, 800)
        self.view.resize(800, 750)
        
        ##End  autogenerated code from QtDesigner
        
        layout.addLayout(self.horizontalLayout_4)
        
        self.btnCancel.setShortcut('Esc')
        self.connect(self.btnOK, QtCore.SIGNAL('clicked(bool)'),
                     self.okTriggered)
        self.connect(self.btnCancel, QtCore.SIGNAL('clicked(bool)'),
                     self.cancel)
#        self.connect(self.btnRunR, QtCore.SIGNAL('clicked(bool)'),
#                     self.updateROutput)
        self.connect(self.view, QtCore.SIGNAL('resize()'),
                     self.resize)
        
        self.scene.wheelEvent = self.wheel_event
#        self.resizeEvent = self.resize_event
        #code to populate the treeview with the contents of our MDS
        self.PopulateTreeview()
        
        self.setLayout(layout)
        self.repaint()
        #utils.breakpoint()
        #code to add in pictureviewer stuff
#        outputPic = self.display_jpeg
#        self.setup_view()
        self.load_picture(self.display_jpeg)
        
    def okTriggered(self):
        self.runR()
        self.done(0)

    def cancel(self):
        self.done(1)
        #raise Exception
#        shutil.copyfile(self.inputMDS, self.outputMDS)
        
    def PopulateTreeview(self):
        self.treeview.setColumnCount(1)
        
        

        csvfile = open(self.csv_file, "rb")
        #print "MDS", self.inputMDS
        reader = csv.reader(csvfile)
        header = reader.next() #store the header
        lines = []
        for row in reader:
            lines.append(row)
        
        i = 1
        for item in header[1:]:
            tooltiptext = ''
            for line in lines:
                try:
                    formatedsecond = "%d4" %line[i]
                except TypeError:
                    formatedsecond = line[i]
                    
                if line[0] != '':
                    if line[0][0].lower() == 's':
                        tooltiptext += line[0] +":\t\t" + formatedsecond +"\n"
                    else:
                        tooltiptext += line[0] +":\t" + formatedsecond +"\n"
                elif line[0] == '' and line[1] != '':
                    tooltiptext += "\n" + line[1] +"\n"
            
            child_item = QtGui.QTreeWidgetItem([item,])
            child_item.setToolTip(0, _fromUtf8(tooltiptext))
            child_item.setFlags(QtCore.Qt.ItemIsUserCheckable |
                                QtCore.Qt.ItemIsEnabled)
            child_item.setCheckState(0, QtCore.Qt.Unchecked)
            self.treeview.addTopLevelItem(child_item)
            i += 1
            
        csvfile.close()
        self.label_2.setText(_fromUtf8("Models previously run:"))
        
   
        
    def runR(self):
#       
        if self.chkEvalHoldout.checkState() == QtCore.Qt.Checked:
            #create a finalModelEvaluation folder
            eval_type = os.path.split(self.findModel.csv_file)[1]
            eval_type = os.path.splitext(eval_type)[0]
            eval_type = eval_type.replace("AcrossModel", "")
            finalFolder = os.path.join(self.session_folder, "FinalModelEvaluation_" + eval_type)
            if os.path.exists(finalFolder):
                msg = "The folder " + "'FinalModelEvaluation_" + eval_type + "' already exists in this session folder."
                msg += "\nThis indicates that the final evaluation metrics have already been calculated."
                msg += "\nThese final statistics are only valid for the first time run."
                msg += "\nThe previous run of statistics will be displayed now."
                msg += "\nIf you really want to re-run these metrics, manually delete the previously created folder 'FinalModelEvaluation_" + eval_type + "'."
                msg += "But from a statistical standpoint this is not advised!"
                msgbox = QtGui.QMessageBox(self)
                msgbox.setText(msg)
                msgbox.exec_()
                return None
            else:
                os.mkdir(finalFolder)
                
        
 
        program = os.path.join(self.rPath, "i386", "Rterm.exe") 
        script = os.path.join(utils.getModelsPath(), "EvaluateNewData.r")
        
        treeviewIter = QtGui.QTreeWidgetItemIterator(self.treeview)
        checked_count = 0
        while treeviewIter.value():
            item = treeviewIter.value()
#            col_index = header.index(item.text(0))
            if item.checkState(0) == QtCore.Qt.Checked:
                checked_count += 1
                origWS = os.path.join(self.session_folder, str(item.text(0)), "modelWorkspace")
                outfolder = os.path.join(finalFolder, str(item.text(0)))
                os.mkdir(outfolder)
                
                args = "ws=" + origWS
                args += " o=" + outfolder
                if self.chkProb.checkState() == QtCore.Qt.Checked:
                    args += " mpt=TRUE"
                else:
                    args += " mpt=FALSE"
                if self.chkBin.checkState() == QtCore.Qt.Checked:
                    args += " mbt=TRUE"
                else:
                    args += " mbt=FALSE"
                if self.chkMess.checkState() == QtCore.Qt.Checked:
                    args += " mes=TRUE"
                else:
                    args += " mes=FALSE"
                
                command = program + " --vanilla -f " + script + " --args " + args
                writetolog("    " + command, False, False)
                utils.runRScript("EvaluateNewData.r", args)
                writetolog("Finished running R for: " + str(item.text(0)) , False, True)
            treeviewIter += 1
        
        if checked_count == 0:
            msg = "No models selected for final evaluation/map production."
            msgbox = QtGui.QMessageBox(self)
            msgbox.setText(msg)
            msgbox.exec_()
        
        elif self.chkEvalHoldout.checkState() == QtCore.Qt.Checked:
            output_disp = os.path.join(finalFolder, "somethinghere")
            self.load_picture(output_disp)
        else:
            msg = "All map production finished."
            msgbox = QtGui.QMessageBox(self)
            msgbox.setText(msg)
            msgbox.exec_()
        
        
        
#        args = "i=" + '"' + MDSfile + '"' + " o=" + '"' + self.displayJPEG + '"' + " m=" + str(self.lineEdit.text())
#        args += " rc=" + self.responseCol
#        
#        if self.chkPresence.checkState() == QtCore.Qt.Checked:
#            args += " pres=TRUE"
#        else:
#            args += " pres=FALSE"
#        if self.chkAbsence.checkState() == QtCore.Qt.Checked:
#            args += " absn=TRUE"
#        else:
#            args += " absn=FALSE"
#        if self.chkBackground.checkState() == QtCore.Qt.Checked:
#            args += " bgd=TRUE"
#        else:
#            args += " bgd=FALSE"

#        command = program + " --vanilla -f " + script + " --args " + args
#        writetolog("    " + command, False, False)
#        if os.path.exists(os.path.join(self.outputDir, "Predictor_Correlation.jpg")):
#            os.remove(os.path.join(self.outputDir, "Predictor_Correlation.jpg"))
#            
#        utils.runRScript('PairsExplore.r', args)

#        p = subprocess.Popen(command, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
#
#        writetolog("   Calculating covariate correlation in r R ")

#        ret = p.communicate()
#        if ret[1]:
#            msg = "An error was encountered in the R script for this module.  The R error message is below - \n"
#            msg += ret[1]
#            writetolog(msg)
#            raise Exception, msg
#        else:
#            writetolog("   Finished in R. ")
#        del(ret)
#        
#        if os.path.exists(os.path.join(self.displayJPEG)):
#            return os.path.join(self.displayJPEG)
#        else:
#            writetolog("Missing output from R processing: " + self.displayJPEG)
#            raise Exception, "Missing output from R processing"

    def load_picture(self, strPicture):
        self.l_pix = QtGui.QPixmap(strPicture)
        if self.view.size().width()  <= self.view.size().height(): 
            self.max_vsize = self.view.size().width() * 0.95
        else: 
            self.max_vsize = self.view.size().height() * 0.95
            
        self.c_view = self.l_pix.scaled(self.max_vsize, self.max_vsize, 
                                            QtCore.Qt.KeepAspectRatio, 
                                            QtCore.Qt.SmoothTransformation) 
        self.view_current()
   
    def view_current(self):
        size_img = self.c_view.size() 
        wth, hgt = QtCore.QSize.width(size_img), QtCore.QSize.height(size_img) 
        self.scene.clear() 
        self.scene.setSceneRect(0, 0, wth, hgt) 
        self.scene.addPixmap(self.c_view) 
        QtCore.QCoreApplication.processEvents() 
        
    def wheel_event (self, event):
        numDegrees = event.delta() / 8 
        numSteps = numDegrees / 15.0 
        self.zoom(numSteps) 
        event.accept() 

    def zoom(self, step):
        zoom_step = 0.06
        self.scene.clear() 
        w = self.c_view.size().width() 
        h = self.c_view.size().height() 
        w, h = w * (1 + zoom_step*step), h * (1 + zoom_step*step) 
        self.c_view = self.l_pix.scaled(w, h, 
                                            QtCore.Qt.KeepAspectRatio, 
                                            QtCore.Qt.SmoothTransformation) 
        self.view_current() 

    def closeEvent(self, event):
        self.cancel()
        
    def resizeEvent(self, event):
        self.load_picture(self.display_jpeg)

class FindModelType():
    
    def __init__(self, session_dir, parent=None):
        self.session_dir = session_dir
        
        #check if multiple model types have been run
        #options are one of ('Binary' or 'Count') 
        #and one of    ('TestTrain' or '' or 'CV')
        globPattern = os.path.join(self.session_dir, "AcrossModel*.csv")
        csvOutputs = glob.glob(globPattern)
        
        if len(csvOutputs) > 1:
            self.which_type = QtGui.QDialog()
            self.which_type.setWindowTitle("Multiple model types found in this Session Folder")
            lbl = QtGui.QLabel(self.which_type)
            widget_layout = QtGui.QVBoxLayout()
            lbl.setText("Multiple model types found in this Session Folder\n\nPlease select the model type you wish to select from and test:\n\n")
            widget_layout.addWidget(lbl)
            
            second_layout = QtGui.QVBoxLayout(parent)
            for model_type in csvOutputs:
                button = QtGui.QPushButton()
                buttonText = os.path.split(model_type)[1].replace('.csv', '')
                button.setText(buttonText)
                button.clicked.connect(lambda: self.button_push(model_type))
#                button.connect(button, QtCore.SIGNAL('clicked(' + model_type + ')'), button_push)
                
                second_layout.addWidget(button)
            
            widget_layout.addLayout(second_layout)
            self.which_type.setLayout(widget_layout)
            self.which_type.exec_()
            
        else:
            self.csv_file = csvOutputs[0]
        
        self.jpeg_file = self.csv_file.replace(".csv", ".jpg")
        
    def button_push(self, model_event):
        self.csv_file = model_event
        self.which_type.accept()