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

subroutine ppgan2(jgano, nbsp, ncmp, vpg, vno)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    integer :: jgano, nbsp, ncmp
    real(kind=8) :: vno(*), vpg(*)
! person_in_charge: jacques.pellet at edf.fr
!
!     PASSAGE DES VALEURS POINTS DE GAUSS -> VALEURS AUX NOEUDS
!     POUR LES TYPE_ELEM AYANT 1 ELREFA
! ----------------------------------------------------------------------
!     IN     JGANO  ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
!            NBSP   NOMBRE DE SOUS-POINTS
!            NCMP   NOMBRE DE COMPOSANTES
!            VPG    VECTEUR DES VALEURS AUX POINTS DE GAUSS
!     OUT    VNO    VECTEUR DES VALEURS AUX NOEUDS
!----------------------------------------------------------------------
    integer :: ino, isp, ipg, icmp, nno, nno2, iadzi, iazk24, npg, jmat, ima
    integer :: vali(2)
    real(kind=8) :: s
    character(len=8) :: ma, typema
    character(len=24) :: valk(2)
    integer, pointer :: typmail(:) => null()
!
! DEB ------------------------------------------------------------------
!
    nno = nint(zr(jgano-1+1))
    npg = nint(zr(jgano-1+2))
    ASSERT(nno*npg.gt.0)
!
    call tecael(iadzi, iazk24)
    nno2 = zi(iadzi+1)
    if (nno2 .lt. nno) then
!       -- POUR CERTAINS ELEMENTS XFEM, IL EST NORMAL QUE NNO < NNO2 :
!          CE SONT DES ELEMENTS QUADRATIQUES QUI SE FONT PASSER POUR DES
!          ELEMENTS LINEAIRES
        ima = zi(iadzi)
        ma = zk24(iazk24)(1:8)
        call jeveuo(ma//'.TYPMAIL', 'L', vi=typmail)
        call jenuno(jexnum('&CATA.TM.NOMTM', typmail(ima)), typema)
        valk (1) = zk24(iazk24-1+3)(1:8)
        valk (2) = typema
        vali (1) = nno2
        vali (2) = nno
        call utmess('F', 'ELEMENTS4_90', nk=2, valk=valk, ni=2,&
                    vali=vali)
    endif
!
! --- PASSAGE DES POINTS DE GAUSS AUX NOEUDS SOMMETS PAR MATRICE
!     V(NOEUD) = P * V(GAUSS)
!
    jmat = jgano + 2
    do 40 icmp = 1, ncmp
        do 30 ino = 1, nno
            do 20 isp = 1, nbsp
                s = 0.d0
                do 10 ipg = 1, npg
                    s = s + zr(jmat-1+(ino-1)*npg+ipg) * vpg((ipg-1)* ncmp*nbsp+(isp-1)*ncmp+icmp&
                        )
10              continue
                vno((ino-1)*ncmp*nbsp+(isp-1)*ncmp+icmp) = s
20          continue
30      continue
40  end do
!
end subroutine
