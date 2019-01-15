//
//  Macros.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 15/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

// References
#define STRONG(obj) __typeof__(obj)
#define WEAK(obj) __typeof__(obj) __weak
#define WEAK_SELF WEAK(self)

//多国语言包
#define lang(stringkey)  NSLocalizedString(stringkey, nil)