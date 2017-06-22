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

subroutine dyexre(numddl, freq, nbexre, exreco, exresu,&
                  j2nd)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsorac.h"
#include "asterfort/vtcopy.h"
#include "asterfort/vtcreb.h"
    character(len=24) :: exreco, exresu
    integer :: nbexre
    character(len=14) :: numddl
    real(kind=8) :: freq
    integer :: j2nd
!
! ----------------------------------------------------------------------
!
! DYNA_VIBRA//HARM/GENE
!
! APPLICATION EXCIT_RESU
!
! ----------------------------------------------------------------------
!
!
! IN  NBEXRE : NOMBRE DE EXCIT_RESU
! IN  NUMDDL : NOM DU NUME_DDL
! IN  EXRECO : LISTE DES COEFFICIENTS DANS EXCIT_RESU
! IN  EXRESU : LISTE DES RESULTATS DANS EXCIT_RESU
! IN  NUMDDL : NOM DU NUME_DDL
! IN  FREQ   : VALEUR DE LA FREQUENCE
! IN  J2ND   : ADRESSE DU VECTEUR ASSEMBLE SECOND MEMBRE
!
!
!
!
    character(len=19) :: chamno, chamn2
    real(kind=8) :: prec, eps0
    integer :: ieq, neq, iresu, ibid, ifreq(1), iret
    character(len=8) :: k8bid
    integer :: jlccre, jlresu
    complex(kind=8) :: c16bid
    complex(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    chamn2 = '&&DYEXRE.CHAMN2'
    call detrsd('CHAM_NO', chamn2)
    call vtcreb(chamn2, 'V', 'C',&
                nume_ddlz = numddl,&
                nb_equa_outz = neq)
    prec = 1.d-6
    eps0 = 1.d-12
    call jeveuo(exreco, 'L', jlccre)
    call jeveuo(exresu, 'L', jlresu)
    do iresu = 1, nbexre
        if (abs(freq) .gt. eps0) then
            call rsorac(zk8(jlresu+iresu-1), 'FREQ', 0, freq, k8bid,&
                        c16bid, prec, 'RELATIF', ifreq, 1,&
                        ibid)
        else
            call rsorac(zk8(jlresu+iresu-1), 'FREQ', 0, freq, k8bid,&
                        c16bid, eps0, 'ABSOLU', ifreq, 1,&
                        ibid)
        endif
        call rsexch('F', zk8(jlresu+iresu-1), 'DEPL', ifreq(1), chamno,&
                    iret)
        call vtcopy(chamno, chamn2, 'F', ibid)
        call jeveuo(chamn2//'.VALE', 'L', vc=vale)
        do ieq = 1, neq
            zc(j2nd-1+ieq) = zc(j2nd-1+ieq) + vale(ieq)*zc( jlccre-1+iresu)
        end do
    end do
!
    call jedema()
end subroutine
