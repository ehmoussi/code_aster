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

subroutine extmod_sorted(basemo, numddl, nume, nbnumo, dmode,&
                  nbeq, nbnoe, iddl, nbddl)
    implicit none
! EXTRAIRE D'UN CONCEPT MODE_MECA LA DEFORMEE POUR UN OU PLUSIEURS DDL
! LES LAGRANGES SONT SUPPRIMES.
!-----------------------------------------------------------------------
! IN  :BASEMO : CONCEPT DE TYPE MODE_MECA
! IN  :NUMDDL : PERMET D'ACCEDER AU PROFIL DU CHAMP_NO EXTRAIT
! IN  :NUME   : LISTE DES NUMEROS D'ORDRE DES MODES CONSIDERES
! IN  :NBNUMO : NB DE MODES CONSIDERES
! IN  :NBEQ   : NB D'EQUATIONS
! IN  :NBNOE  : NB DE NOEUDS DU MAILLAGE
! IN  :IDDL   : LISTE DES INDICES DES DDL A EXTRAIRE
! IN  :NBDDL  : NB DE DDLS A EXTRAIRE
! OUT :DMODE  : VECTEUR => DEFORMEES MODALES
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
    integer :: nbddl, nbnumo, nbnoe, nume(nbnumo), iddl(nbddl)
    real(kind=8) :: dmode(nbddl*nbnoe*nbnumo)
    character(len=8) :: basemo
    character(len=14) :: numddl
    character(len=24) :: deeq, nomcha
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: iadmod, ideeq, inumo, iret
    integer :: k, nbeq, iinod, iiddl, ieq, im
!-----------------------------------------------------------------------
    call jemarq()
    deeq = numddl//'.NUME.DEEQ'
    call jeveuo(deeq, 'L', ideeq)
    do im = 1, nbnumo
        inumo = nume(im)
        call rsexch('F', basemo, 'DEPL', inumo, nomcha,&
                    iret)
        nomcha = nomcha(1:19)//'.VALE'
        call jeveuo(nomcha, 'L', iadmod)
        do ieq = 1, nbeq
!           --- iinod is the node index w.r.t the order in the original mesh file
            iinod = zi(ideeq+(2*ieq)-2)
            iiddl = zi(ideeq+(2*ieq)-1)
            do k = 1, nbddl
                if (iiddl .eq. iddl(k)) then
                    dmode((im-1)*nbnoe*nbddl+(iinod-1)*nbddl+k) = zr(iadmod+ieq-1)
                    goto 22
                endif
            end do
22          continue
        end do
    end do
!
    call jedema()
end subroutine
