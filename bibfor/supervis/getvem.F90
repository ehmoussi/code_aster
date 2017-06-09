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

subroutine getvem(noma, typent, motfac, motcle, iocc,&
                  iarg, mxval, vk, nbval)
    implicit none
#include "asterfort/getvtx.h"
#include "asterfort/verima.h"
    character(len=*) :: noma, typent, motfac, motcle, vk(*)
    integer :: iocc, iarg, mxval, nbval
!       RECUPERATION DES VALEURS D'UNE LISTE (VOIR POINT D'ENTREE)
!     ------------------------------------------------------------------
! IN  MOTFAC : CH*(*) : MOT CLE FACTEUR
!          CONVENTION :  POUR UN MOT CLE SIMPLE   MOTFAC = ' '
! IN  MOTCLE : CH*(*) : MOT CLE
! IN  IOCC   : IS     : IOCC-IEME OCCURENCE DU MOT-CLE-FACTEUR
! IN  IARG   : IS     : IARG-IEME ARGUMENT DEMANDE
! IN  MXVAL  : IS     : TAILLE MAXIMUM DU TABLEAU PASSE
!                     :                   (RELATIVEMENT AU TYPE)
!
! OUT   VAL  : ----   : TABLEAU DES VALEURS A FOURNIR
! OUT NBVAL  : IS     : NOMBRE DE VALEUR FOURNIT
!          CONVENTION : SI NBVAL = 0 ==> IL N'Y A PAS DE VALEUR
!                       SI NBVAL < 0 ==> NOMBRE DE VALEUR DE LA LISTE
!                                        SACHANT QUE L'ON NE FOURNIT QUE
!                                        LES MXVAL PREMIERES
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: mm
!-----------------------------------------------------------------------
    call getvtx(motfac, motcle, iocc=iocc, nbval=mxval, vect=vk,&
                nbret=nbval)
    if (mxval .ne. 0) then
        mm=min(mxval,abs(nbval))
        call verima(noma, vk, mm, typent)
    endif
end subroutine
