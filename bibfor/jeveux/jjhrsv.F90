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

subroutine jjhrsv(idts, nbval, iadmi)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "jeveux.h"
#include "jeveux_private.h"
#include "asterc/hdfcld.h"
#include "asterc/hdfrsv.h"
#include "asterc/hdftsd.h"
#include "asterfort/jjalls.h"
#include "asterfort/jjlidy.h"
#include "asterfort/utmess.h"
    integer :: idts, nbval, iadmi
! ----------------------------------------------------------------------
! RELIT UN SEGMENT DE VALEURS ASSOCIE A UN OBJET JEVEUX, LE TYPE INTEGER
! EST TRAITE DE FACON PARTICULIERE POUR S'AJUSTER A LA PLATE-FORME
!
! IN  IDTS   : IDENTIFICATEUR DU DATASET HDF
! IN  NBVAL  : NOMBRE DE VALEURS DU DATASET
! IN  IADMI  : ADRESSE DANS JISZON DU TABLEAU DE VALEURS LUES
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: istat
    common /istaje/  istat(4)
! ----------------------------------------------------------------------
    real(kind=8) :: svuse, smxuse
    common /statje/  svuse,smxuse
! ----------------------------------------------------------------------
    integer :: iret, jadr, kadm, nbv, k, lonoi, ltypi
    integer :: ir, kitab, iconv, iadyn
    character(len=1) :: typei
! DEB ------------------------------------------------------------------
    iconv = 0
    ltypi = 0
    nbv = 0
    iret = hdftsd(idts,typei,ltypi,nbv)
    if (iret .ne. 0) then
        call utmess('F', 'JEVEUX_52')
    endif
    if (typei .eq. 'I') then
        iconv = 1
        if (lois .lt. ltypi) then
            lonoi = nbval*ltypi
            call jjalls(lonoi, 0, 'V', typei, lois,&
                        'INIT', zi, jadr, kadm, iadyn)
            iszon(jiszon+kadm-1) = istat(2)
            iszon(jiszon+iszon(jiszon+kadm-4)-4) = istat(4)
            svuse = svuse + (iszon(jiszon+kadm-4) - kadm + 4)
            smxuse = max(smxuse,svuse)
            ir = iszon(jiszon + kadm - 3 )
            kitab = jk1zon+(kadm-1)*lois+ir+1
            iret = hdfrsv(idts,nbv,k1zon(kitab),iconv)
            do 1 k = 1, nbv
                iszon(jiszon+iadmi-1+k)=iszon(jiszon+kadm-1+k)
 1          continue
            call jjlidy(iadyn, kadm)
        else
            ir = iszon(jiszon + iadmi - 3 )
            kitab = jk1zon+(iadmi-1)*lois+ir+1
            iret = hdfrsv(idts,nbv,k1zon(kitab),iconv)
        endif
    else
        ir = iszon(jiszon+iadmi-3)
        kitab = jk1zon+(iadmi-1)*lois+ir+1
        iret = hdfrsv(idts,nbv,k1zon(kitab),iconv)
    endif
    if (iret .ne. 0) then
        call utmess('F', 'JEVEUX_53')
    endif
    iret = hdfcld(idts)
! FIN ------------------------------------------------------------------
end subroutine
