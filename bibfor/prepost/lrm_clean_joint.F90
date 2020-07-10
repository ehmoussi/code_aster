! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine lrm_clean_joint(rang, domdis, nbproc, v_noex, name_join_old, name_join_new)
!
    implicit none
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterc/asmpi_comm.h"
#include "asterc/asmpi_recv_i.h"
#include "asterc/asmpi_send_i.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
!
    integer, intent(in) :: rang, domdis, nbproc
    integer, intent(inout) :: v_noex(*)
    character(len=24), intent(in) :: name_join_old, name_join_new
!
!
! ---------------------------------------------------------------------------------------------
!
! LECTURE DU FORMAT MED : Nettoyage des joints pour le ParallelMesh
!
!     On a lu l'info de tout les joints quelques soient leurs types car med le permet
!     mais il faut faire un tri maintenant dans les correspondances pour garder que celles
!     qui nous intéresse
!     Type de correspondance (entre deux noeuds uniquement pour le moment):
!     - noeud interne - noeud joint (il faut le garder)
!     - noeud joint   - noeud joint (il faut le supprimer car ne sert à rien pour nous)
!
! ---------------------------------------------------------------------------------------------
!
    character(len=8) :: k8bid
    integer :: nb_corr, nb_node, ino, numno, deca
    mpi_int :: mpicou, count, dest, tag, source
    integer, pointer :: v_nojo(:) => null()
    integer, pointer :: v_name_join_old(:) => null()
    integer, pointer :: v_name_join_new(:) => null()
    aster_logical :: l_send
!
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
!
    if(name_join_old(10:10) == "R") then
        l_send = ASTER_FALSE
    elseif(name_join_old(10:10) == "E") then
        l_send = ASTER_TRUE
    else
        ASSERT(ASTER_FALSE)
    end if
!
! --- Il faut préparer les noeuds à envoyer et à recevoir
!
    call jelira(name_join_old, 'LONMAX', nb_corr, k8bid)
    nb_node = nb_corr/2
!
    call wkvect("&&LRMJOI.NOJO", 'V V I', nb_node, vi=v_nojo)
!
! --- 0 le noeud m'appartient et -1 le noeud ne m'appartient pas
!
    call jeveuo(name_join_old, 'L', vi=v_name_join_old)
    deca = 1
    if(l_send) then
        do ino = 1, nb_node
            numno = v_name_join_old(deca)
            if(v_noex(numno) .ne. rang) then
                v_nojo(ino) = -1
            end if
            deca = deca +2
        end do
    end if
!
! --- Envoie des informations pour le joint
!
    if(l_send) then
        tag = to_mpi_int(domdis*nbproc + rang)
    else
        tag = to_mpi_int(rang*nbproc + domdis)
    end if
    count = to_mpi_int(nb_node)
    dest = to_mpi_int(domdis)
    source = to_mpi_int(domdis)
!
    if(l_send) then
        call asmpi_send_i(v_nojo, count, dest, tag, mpicou)
    else
        call asmpi_recv_i(v_nojo, count, source, tag, mpicou)
    end if
!
! --- Il faut supprimer les correspondances en trop maintenant dans le joint
!
    nb_corr = 0
    do ino = 1, nb_node
        if(v_nojo(ino) == 0) then
            nb_corr = nb_corr + 1
        end if
    end do
!
!   print*, "NEW: ", l_send, rang, domdis, nb_node, nb_corr, name_join_new
    call wkvect(name_join_new, 'G V I', 2*nb_corr, vi=v_name_join_new)
!
    deca = 0
    do ino = 1, nb_node
        if(v_nojo(ino) == 0) then
            v_name_join_new(deca+1) = v_name_join_old((ino-1)*2+1)
            v_name_join_new(deca+2) = v_name_join_old((ino-1)*2+2)
            if(.not.l_send) then
                ASSERT(v_noex(v_name_join_new(deca+1)) == -1)
                v_noex(v_name_join_new(deca+1)) = domdis
            end if
            deca = deca + 2
        end if
    end do
    ASSERT(deca == 2*nb_corr)
!
! --- Il faut détruire les objets temporaires
!
    call jedetr("&&LRMJOI.NOJO")
!
    call jedema()
!
end subroutine
