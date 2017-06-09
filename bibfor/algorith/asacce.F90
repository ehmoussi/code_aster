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

subroutine asacce(nomsy, monoap, nbsup, neq,&
                  nbmode, id, moncha, vecmod, momec,&
                  gamma0, recmor, recmod, nbdis, nopara,&
                  nordr)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/rsadpa.h"
#include "asterfort/pteddl.h"
#include "asterfort/wkvect.h"
    integer :: nbsup, neq, nbmode, id, nbdis(nbsup), nordr(*)
    real(kind=8) :: vecmod(neq, *), gamma0(*)
    real(kind=8) :: recmod(nbsup, neq, *), recmor(nbsup, neq, *)
    character(len=16) :: nomsy, nopara(*)
    character(len=*) :: moncha, momec
    aster_logical :: monoap
!     COMMANDE : COMB_SISM_MODAL
!        CALCUL DES ACCELERATIONS ABSOLUES
!     ------------------------------------------------------------------
! IN  : NOMSY  : OPTION DE CALCUL
! IN  : MONOAP : =.TRUE.  , CAS DU MONO-SUPPORT
!                =.FALSE. , CAS DU MULTI-SUPPORT
! IN  : NBSUP  : NOMBRE DE SUPPORTS
! IN  : NEQ    : NOMBRE D'EQUATIONS
! IN  : NBMODE : NOMBRE DE MODES
! IN  : ID     : LA DIRECTION DE CALCUL
! IN  : VECMOD : VECTEUR DES DEFORMEES MODALES
! IN  : MOMEC  : MODES MECANIQUES
! IN  : GAMMA0 : VECTEUR DES CORRECTIONS STATIQUES
! IN  : RECMOD : VECTEUR DES COMBINAISONS DES REPONSES PERIO DES MODES
! IN  : RECMOR : VECTEUR DES COMBINAISONS DES REPONSES RIGIDES DES MODES
! OUT : RECMOD : VECTEUR DES RECOMBINAISONS MODALES
! IN  : NBDIS  : APPARTENANCE DES SUPPORTS AUX INTRAGROUPES
! IN  : NORDR  : LISTE DES NUMEROS DE MODES
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: im, in, is, jmod, juni, ioc, ival
    real(kind=8) :: xxx
    character(len=8) :: nomcmp(3)
!     ------------------------------------------------------------------
    data nomcmp / 'DX' , 'DY' , 'DZ' /
!     ------------------------------------------------------------------
!
    call jemarq()
!
    if (monoap) then
!       SOMME DES CARRES DES REPONSES PERIO ET RIGIDES
        do in = 1, neq
            ioc = nbdis(1)
!         VALEUR DE IOC REFERENCE A ASCORM.F
            recmod(ioc,in,id) = recmod(ioc,in,id)+ (recmor(ioc,in,id)* recmor(ioc,in,id))
        enddo
    endif
!
    if (nomsy(1:4) .eq. 'ACCE') then
        if (monoap) then
            is=nbsup
!
!           --- CONTRIBUTION MODALE ---
            call wkvect('&&ASTRON.VECTEUR_MODA', 'V V R', neq, jmod)
            do im = 1, nbmode
                call rsadpa(momec, 'L', 1, nopara(2+id), nordr(im),&
                            0, sjv=ival, istop=0)
                xxx = zr(ival)
                do in = 1, neq
                    zr(jmod+in-1) = zr(jmod+in-1) + xxx*vecmod(in,im)
                enddo
            enddo
!
!           --- VECTEUR UNITAIRE DANS LA DIRECTION ID ---
            call wkvect('&&ASTRON.VECTEUR_UNIT', 'V V I', neq, juni)
            call pteddl('CHAM_NO', moncha, 1, nomcmp(id), neq,&
                        list_equa = zi(juni))
!
            do in = 1, neq
                xxx = gamma0(id) * ( zi(juni+in-1) - zr(jmod+in-1) )
                recmod(is,in,id) = recmod(is,in,id) + xxx*xxx
            enddo
            call jedetr('&&ASTRON.VECTEUR_UNIT')
            call jedetr('&&ASTRON.VECTEUR_MODA')
        else
            is=1
!
!           --- CONTRIBUTION MODALE ---
            call wkvect('&&ASTRON.VECTEUR_MODA', 'V V R', neq, jmod)
            do im = 1, nbmode
                call rsadpa(momec, 'L', 1, nopara(2+id), nordr(im),&
                            0, sjv=ival, istop=0)
                xxx = zr(ival)
                do in = 1, neq
                    zr(jmod+in-1) = zr(jmod+in-1) + xxx*vecmod(in,im)
                enddo
            enddo
!
!           --- VECTEUR UNITAIRE DANS LA DIRECTION ID ---
            call wkvect('&&ASTRON.VECTEUR_UNIT', 'V V I', neq, juni)
            call pteddl('CHAM_NO', moncha, 1, nomcmp(id), neq,&
                        list_equa = zi(juni))
!
            do in = 1, neq
                xxx = gamma0(is+nbsup*(id-1)) * ( zi(juni+in-1) - zr(jmod+in-1) )
                recmod(is,in,id) = recmod(is,in,id) + xxx*xxx
            enddo
            call jedetr('&&ASTRON.VECTEUR_UNIT')
            call jedetr('&&ASTRON.VECTEUR_MODA')
        endif
    endif
!
    call jedema()
end subroutine
