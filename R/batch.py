#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 21 16:44:52 2020

@author: bo
"""

def batch(X, Y, betas, inter, learning_rate=0.01):
    
    y_pred = inter + X.dot(betas)
    
    # compute gradients
    db = -2*(X*(Y - y_pred))
    dinter = -2*(Y - y_pred)
      
    # updates
    betas = betas - learning_rate*db
    inter = inter - learning_rate*dinter

    return betas, inter