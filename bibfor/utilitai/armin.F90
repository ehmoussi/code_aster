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

function armin(nomaz)
    implicit none
    real(kind=8) :: armin
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbliva.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomaz
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE - MAILLAGE
!
! CETTE FONCTION PERMET DE RECUPERER LA PLUS PETITE ARETE DU MAILLAGE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA  : NOM DU MODELE
! OUT ARMIN : TAILLE DE LA PLUS PETITE ARETE DU MAILLAGE
!
!
!
!
    character(len=8) :: noma, k8b
    character(len=19) :: nomt19
    character(len=24) :: para
    integer :: ibid, ier
    integer :: nbpar
    real(kind=8) :: r8b, arete
    complex(kind=8) :: cbid
!
! ----------------------------------------------------------------------
!
    call jemarq()
    r8b=0.d0
!
! --- RECUPERATION DE L'ARETE MINIMUM DU MAILLAGE
!
    noma = nomaz
    call jeexin(noma//'           .LTNT', ier)
    if (ier .ne. 0) then
        call ltnotb(noma, 'CARA_GEOM', nomt19)
        nbpar = 0
        para = 'AR_MIN                  '
        call tbliva(nomt19, nbpar, ' ', [ibid], [r8b],&
                    [cbid], k8b, k8b, [r8b], para,&
                    k8b, ibid, arete, cbid, k8b,&
                    ier)
        if (ier .eq. 0) then
            armin = arete
        else
            call utmess('F', 'MODELISA2_13')
        endif
    else
        call utmess('F', 'MODELISA3_18')
    endif
!
    call jedema()
!
end function
