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

subroutine xthpoc(modele, chtn, chtpg)
    implicit none
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/megeom.h"
    character(len=19) :: chtn, chtpg
    character(len=24) :: modele
! ----------------------------------------------------------------------
!
! THER_LINEAIRE + XFEM : APPEL A CALCUL POUR L'OPTION 'TEMP_ELGA'
!
! IN  MODELE  : NOM DU MODELE
! IN  CHTN    : CHAMP DE TEMPERATURE AUX NOEUDS
! OUT CHTPG   : CHAMP DE TEMPERATURE AUX PG
!
! ----------------------------------------------------------------------
    integer :: nbin, nbout
    parameter    (nbin=10)
    parameter    (nbout=1)
    character(len=8) :: lpain(nbin), lpaout(nbout)
    character(len=16) :: option
    character(len=19) :: ligrmo, pintto, cnseto, heavto, loncha, basloc, lsn
    character(len=19) :: lst, hea_no
    character(len=24) :: lchin(nbin), lchout(nbout), chgeom
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call megeom(modele, chgeom)
    pintto = modele(1:8)//'.TOPOSE.PIN'
    cnseto = modele(1:8)//'.TOPOSE.CNS'
    heavto = modele(1:8)//'.TOPOSE.HEA'
    loncha = modele(1:8)//'.TOPOSE.LON'
    basloc = modele(1:8)//'.BASLOC'
    lsn = modele(1:8)//'.LNNO'
    lst = modele(1:8)//'.LTNO'
    hea_no = modele(1:8)//'.TOPONO.HNO'
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PTEMPER'
    lchin(2) = chtn
    lpain(3) = 'PPINTTO'
    lchin(3) = pintto
    lpain(4) = 'PCNSETO'
    lchin(4) = cnseto
    lpain(5) = 'PHEAVTO'
    lchin(5) = heavto
    lpain(6) = 'PLONCHA'
    lchin(6) = loncha
    lpain(7) = 'PBASLOR'
    lchin(7) = basloc
    lpain(8) = 'PLSN'
    lchin(8) = lsn
    lpain(9) = 'PLST'
    lchin(9) = lst
    lpain(10) = 'PHEA_NO'
    lchin(10) = hea_no
!
    lpaout(1) = 'PTEMP_R'
    lchout(1) = chtpg
!
    option = 'TEMP_ELGA'
    ligrmo = modele(1:8)//'.MODELE'
!
!     RQ : LIGRMO CONTIENT TOUS LES EF DU MODELE, MAIS SEULS LES EF
!     ---  X-FEM SAVENT CALCULER L'OPTION 'TEMP_ELGA'
    call calcul('S', option, ligrmo, nbin, lchin,&
                lpain, nbout, lchout, lpaout, 'V',&
                'OUI')
!
    call jedema()
!
end subroutine
