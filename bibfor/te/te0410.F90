! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine te0410(optioz, nomtz)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/vdefro.h"
#include "asterfort/vdrepe.h"
#include "asterfort/vdsiro.h"
#include "asterfort/vdxedg.h"
#include "asterfort/vdxsig.h"
#include "asterfort/postcoq3d.h"
!
    character(len=*) :: optioz, nomtz
!
    character(len=16) :: option, nomte
!     ----------------------------------------------------------------
!     CALCUL DES OPTIONS DES ELEMENTS DE COQUE 3D
!                EPSI_ELGA
!                SIEF_ELGA
!                DEGE_ELGA
!                DEGE_ELNO
!

!-----------------------------------------------------------------------
    integer :: jcou
    integer :: nbcou
! DEB
!
    option=optioz
    nomte=nomtz
!
    call jevech('PNBSP_I', 'L', jcou)
    nbcou=zi(jcou)
    call postcoq3d(option, nomte, nbcou)
!
end subroutine
